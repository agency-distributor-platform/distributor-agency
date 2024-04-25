require "#{Rails.root}/lib/buyer_obj.rb"

module ItemService
  class ItemStatusObj

    include BusinessLogic

    attr_reader :record

    def self.create_obj(item_obj, agency_id)
      new(ItemStatus.new({item_type: item_obj.model_name, item_id: item_obj.record_id, agency_id: }))
    end

    def self.get_items(filter_hash)
      results = []
      ItemStatus.includes(:status).includes(:distributor).includes(:salesperson).includes(:buyer).where(filter_hash).each { |record|
        record_hash = record.as_json
        record_hash["#{record_hash["item_type"]}_details"] = record.item.as_json
        record_hash["salesperson_details"] = record.salesperson.as_json_with_converted_id rescue nil
        record_hash.delete(:salesperson_id)
        record_hash["status_details"] = record.status.as_json
        record_hash.delete(:status_id)
        record_hash["distributor_details"] = record.distributor.as_json_with_converted_id rescue nil
        record_hash.delete(:distributor_id)
        #TO-DO -> Make this better, too specific for vehicle
        record_hash["vehicle_model_details"] = record.item.vehicle_model.as_json rescue nil
        record_hash["buyer_details"] = record.buyer.as_json_with_converted_id rescue nil
        results.push(record_hash)
      }
      results
    end

    def initialize(record)
      @record = record[:id] ? ItemStatus.includes(:transactions).find_by(id: record[:id]) : ItemStatus.includes(:transactions).new(record.as_json)
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

    def get_transactions
      transactions_list = []
      record.transactions.order(:id).each { |transaction_record|
        transaction_obj = TransactionObj.new(transaction_record)
        transaction_details = transaction_obj.get_transaction_details
        transactions_list.push(transaction_obj.as_json.merge!({transaction_details: }))
      }
      transactions_list
    end

    private

    def record_id
      record.id
    end

  end
end
