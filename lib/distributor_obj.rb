require_relative "./agency_obj.rb"

module BusinessLogic
  class DistributorObj

    attr_accessor :record, :agency

    def initialize(record)
      @record = record[:id].present? ? Distributor.find_by(id: record[:id]) : Distributor.new(record)
    end

    def update(params)
      record.update(params)
    end

    def link_to_agency(agency_obj)
      if record_present?
        return if agency_obj.distributors.pluck(:id).include?(record_id)
        record.agency = agency_obj.record
        record.save!
      else
        raise "Wrong distributor record"
      end
    end

    def agency
      @agency = @agency || derive_agency_obj
      @agency
    end

    def derive_item_obj_class(item_type)
      "BusinessLogic::#{item_type.capitalize}Obj".constantize
    end

    def record_present?
      record.persisted?
    end

    def record_id
      record.id
    end

    def get_buyers
      buyers = []
      record.item_mappings.each { |item_mapping|
        buyer_json = item_mapping.buyer.as_json rescue nil
        buyers.push(buyer_json) if buyer_json.present?
      }
      buyers
    end

    def get_buyer(buyer_id)
      Buyer.find_by(id: buyer_id).as_json if valid_buyer(buyer_id)
    end

    def is_valid_vehicle?(item_obj)
      item_obj.distributor.eql?(self)
    end

    def eql?(other_distributor_obj)
      record == other_distributor_obj.record
    end

    def get_earnings
      revenue = 0
      record.item_statuses.each { |item|
        item_status_obj = ItemService::ItemStatusObj.new(item)
        revenue = revenue + item_status_obj.distributor_share
      }

      {
        revenue_on_paper: revenue,
        total_revenue: revenue
      }
    end

    private

    def valid_buyer(buyer_id)
      record.item_mappings.pluck(:buyer_id).include?(buyer_id)
    end

    def derive_model(item_type)
      "#{item_type.capitalize}".constantize
    end

    def derive_agency_obj
      agency_record = record.agency
      BusinessLogic::AgencyObj.new(agency_record) if agency_record.present?
    end

  end
end
