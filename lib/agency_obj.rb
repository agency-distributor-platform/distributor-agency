# require_relative "./adapters/google_drive.rb"
require_relative "./adapters/s3_file.rb"

module BusinessLogic
  class AgencyObj

    include Adapters
    attr_reader :record

    def initialize(record)
      @record = record[:id].present? ? Agency.find_by(id: record[:id]) : Agency.new(record)
    end

    def distributors
      record.distributors
    end

    def exists_in_db?
      record.persisted?
    end

    def update(params)
      record.update(params)
    end

    def as_json
      record.as_json
    end

    def get_sold_items(item_type, limit, page_number)
      offset = page_number*limit + 1 #page number is received, we get db offset
      item_obj_class = derive_item_obj_class(item_type)
      item_obj_class.get_sold_items(ItemMapping.eager_load(:distributor).eager_load(:agency).where(agency_id: record_id).where(item_type: ), limit, offset)
    end

    def get_distributors(limit, offset)
      offset = offset*limit #page number is received, we get db offset
      record.distributors.offset(offset).limit(limit).as_json
    end

    def get_distributor(distributor_id)
      record.distributors.find_by(id: distributor_id).as_json rescue nil
    end

    def get_buyers
      buyers = []
      record.item_mappings.each { |item_mapping|
        buyer_json = item_mapping.buyer.as_json rescue nil
        buyers.push(buyer_json) if buyer_json.present?
      }
      buyers.uniq
    end

    def get_buyer(buyer_id)
      Buyer.find_by(id: buyer_id).as_json if valid_buyer(buyer_id)
    end

    def get_items(item_type)
      item_ids = ItemMapping.where({agency_id: record_id, item_type: }).pluck(:item_id)
      derive_model(item_type).where(id: item_ids).as_json
    end

    def get_earnings
      total_earnings = {
        revenue_on_paper: 0,
        actual_revenue: 0,
        distributor_share: 0,
        salesperson_share: 0
      }
      record.item_statuses.each { |item|
        item_status_obj = ItemService::ItemStatusObj.new(item)
        total_revenue_hash = item_status_obj.total_revenue
        total_earnings[:revenue_on_paper] = total_earnings[:revenue_on_paper] + total_revenue_hash[:revenue_on_paper]
        total_earnings[:actual_revenue] = total_earnings[:actual_revenue] + total_revenue_hash[:actual_revenue]
        total_earnings[:distributor_share] = total_earnings[:distributor_share] + item_status_obj.distributor_share
        total_earnings[:salesperson_share] = total_earnings[:salesperson_share] + item_status_obj.salesperson_share
      }
      total_earnings
    end

    def get_item(item_details)
      item_type = item_details[:item_type]
      item_id = item_details[:item_id]
      derive_model(item_type).find_by(id: item_id).as_json if ItemMapping.where({agency_id: record_id, item_type: , item_id: }).present?
    end

    def record_id
      record.id
    end

    def is_valid_vehicle?(item_obj)
      item_obj.agency.eql?(self)
    end

    def eql?(other_agency_obj)
      record == other_agency_obj.record
    end

    def create_s3_folder
      s3_adapter = S3File.new
      s3.create_folder(agency_s3_path)
    end

    def list_salesperson_linking_requests(linking_request_filter)
      linkings = []
      record.salesperson_agency_linkings.where(linking_request_filter).as_json.each { |linking|
        salesperson = Salesperson.find_by(id: linking["salesperson_id"]).as_json
        linking[:salesperson_details] = salesperson
        linkings.push(linking)
      }
      linkings
    end

    def approve_salesperson_linking_request(linking_id, approval)
      salesperson_agency_linking = record.salesperson_agency_linkings.find_by(id: linking_id)
      raise "Invalid Linking Id" if salesperson_agency_linking.blank?
      if approval == "approved"
        salesperson_agency_linking.update!(is_verified: true)
        salesperson_agency_linking.update!(rejected: false)
      elsif approval == "rejected"
        salesperson_agency_linking.update!(is_verified: false)
        salesperson_agency_linking.update!(rejected: true)
      else
        raise "Invalid Approval Status"
      end
    end

    private

    def derive_item_obj_class(item_type)
      "BusinessLogic::#{item_type.capitalize}Obj".constantize
    end

    def valid_buyer(buyer_id)
      record.item_mappings.pluck(:buyer_id).include?(buyer_id)
    end

    def derive_model(item_type)
      "#{item_type.capitalize}".constantize
    end

    def agency_s3_path
      "Agency_#{record.name}_#{record.id}"
    end

  end
end
