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
      ItemStatus.includes(:status).includes(:distributor).includes(:salesperson).where(filter_hash).each { |record|
        record_hash = record.as_json
        record_hash["salesperson_details"] = record.salesperson.as_json
        record_hash.delete(:salesperson_id)
        record_hash["status_details"] = record.status.as_json
        record_hash.delete(:status_id)
        record_hash["distributor_details"] = record.distributor.as_json
        record_hash.delete(:distributor_id)
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
        byebug
        transaction_obj.create_record(self)
        transaction_strategy.set_transaction_obj(transaction_obj)
        transaction_strategy.implement
      }
    end

    def add_buyer(buyer_details)
      buyer_obj = BusinessLogic::BuyerObj.new({id: buyer_details[:id]})
      buyer_obj.create_or_update(buyer_details)
      record.buyer = buyer_obj.record
      record.save!
    end

    private

    def record_id
      record.id
    end

  end
end
