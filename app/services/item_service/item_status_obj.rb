require "#{Rails.root}/lib/buyer_obj.rb"

module ItemService
  class ItemStatusObj

    include BusinessLogic
    extend Utils::Pagination
    attr_reader :record

    def self.create_obj(item_obj, agency_id)
      new(ItemStatus.new({item_type: item_obj.model_name, item_id: item_obj.record_id, agency_id: }))
    end

    def self.get_items(filter_hash, id_ordering_type="ASC")
      results = []
      instance = new
      page, per_page = instance.get_page_and_remove_from_filter(filter_hash)
      query = ItemStatus.includes(:status).includes(:distributor).includes(:salesperson).includes(:buyer).where(filter_hash).order("id #{id_ordering_type}")
      data, meta = paginate(query, page, per_page)
      data.each { |record|
        results.push(get_item_hash(record))
      }
      [results, meta]
    end

    def self.get_item_hash(record)
      record_hash = record.as_json
      if record.item_type == "Vehicle"
        vehicle_obj = ItemService::VehicleObj.new({id: record.item_id}) rescue nil
        record_hash["vehicle_model_details"] = record.item.vehicle_model.as_json rescue nil
        record_hash[:photos] = vehicle_obj.get_photos rescue []
      end
      record_hash["#{record_hash["item_type"]}_details"] = record.item.as_json
      record_hash["salesperson_details"] = record.salesperson.as_json_with_converted_id rescue nil
      record_hash.delete(:salesperson_id)
      record_hash["status_details"] = record.status.as_json
      record_hash.delete(:status_id)
      record_hash["distributor_details"] = record.distributor.as_json_with_converted_id rescue nil
      record_hash.delete(:distributor_id)
      record_hash["buyer_details"] = record.buyer.as_json_with_converted_id rescue nil
      record_hash["selling_price"] = record.selling_transactions.first.selling_price rescue "N/A"
      record_hash["distributor_share"] = record.distributor_share rescue 0
      record_hash["salesperson_share"] = record.salesperson_share rescue 0
      record_hash
    end

    def initialize(record=nil)
      if record.present?
        @record = record[:id] ? ItemStatus.includes(:transactions).find_by(id: record[:id]) : ItemStatus.includes(:transactions).new(record.as_json)
      end
    end

    def set_added_status
      record.status_id = Status.find_by(name: "Added").id
      record.save!
    end

    def update_agency(agency_id)
      record.update(agency_id: ) if record.agency_id != agency_id
    end

    def update_status(status)
      record.status = status if record.status != status
      record.save!
    end

    def assign_item(distributor_obj)
      distributor_id = distributor_obj.record_id
      record.update({distributor_id: }) if record.distributor_id != distributor_id
    end

    def as_json
      record.as_json
    end

    def transact(transaction_obj, transaction_strategy)
      #TO-DO: If already sold, raise error
      ApplicationRecord.transaction {
        transaction_obj.create_record(self)
        transaction_strategy.set_transaction_obj(transaction_obj)
        transaction_strategy.implement
      }
    end

    def transactions_by_type(transaction_type)
      record.send(transaction_type)
    end

    def add_buyer(buyer_details)
      buyer_obj = BusinessLogic::BuyerObj.new({id: buyer_details[:id]})
      buyer_obj.create_or_update(buyer_details)
      record.buyer = buyer_obj.record
      record.save!
    end

    def agency
      BusinessLogic::AgencyObj.new(record.agency)
    end

    def distributor
      distributor_record = record.distributor
      BusinessLogic::DistributorObj.new(distributor_record) if distributor_record.present?
    end

    def salesperson
      salesperson_record = record.salesperson
      BusinessLogic::SalespersonObj.new(salesperson_record) if salesperson_record.present?
    end

    def update_share(share_type, share)
      record.send("#{share_type}=", share)
      record.save!
    end

    def get_transactions(page, per_page)
      per_page ||= 10
      transactions_list = []
      data, meta = paginate(record.transactions.order(:id), page, per_page)
      data.each { |transaction_record|
        transaction_obj = TransactionObj.new(transaction_record)
        transaction_details = transaction_obj.get_transaction_details
        transactions_list.push(transaction_obj.as_json.merge!({transaction_details: }))
      }
      [transactions_list, meta]
    end

    def total_revenue

      revenue = {
        revenue_on_paper: 0,
        actual_revenue: 0
      }

      latest_selling_transaction_record = transactions_by_type("selling_transactions").last
      return revenue if latest_selling_transaction_record.blank?

      selling_price = latest_selling_transaction_record.selling_price

      revenue = {
        revenue_on_paper: selling_price,
        actual_revenue: selling_price - latest_selling_transaction_record.due_price
      }

      revenue
    end

    def distributor_share
      distributor_share = record.distributor_share
      if distributor_share.present?
        distributor_share
      else
        0
      end
    end

    def salesperson_share
      salesperson_share = record.salesperson_share
      if salesperson_share.present?
        salesperson_share
      else
        0
      end
    end

    def get_page_and_remove_from_filter(filter_hash)
      page = filter_hash[:page]
      per_page = filter_hash[:per_page]
      filter_hash.delete(:page)
      filter_hash.delete(:per_page)
      return page, per_page
    end

    private
    def record_id
      record.id
    end

  end
end
