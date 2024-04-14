require "#{Rails.root}/lib/utils/transaction_utils.rb"

module ItemService
  class ItemObj

    include Utils

    attr_reader :record

    def self.bulk_upload(records)
      error_records = []
      records.each { |record|
        self.new(record).create_or_update rescue error_records.push(record)
      }
      error_records
    end

    def initialize(record)
      @record = record[:id] ? model.find_by(id: record[:id]) : model.new(record.as_json)
    end

    def record_id
      record.id
    end

    def agency_id
      record.agency.id
    end

    def create_or_update(params, agency_id=nil)
      ApplicationRecord.transaction {
        if !(record.persisted?)
          update(params)
          raise "No Agency found" if agency_id.blank?
          item_status_obj = ItemStatusObj.create_obj(self, agency_id)
          item_status_obj.set_added_status
        else
          update(params)
        end
      }
    end

    def item_status_obj
      ItemStatusObj.new(record.item_status)
    end

    def as_json
      record.as_json
    end

    def transact_item(transact_params)
      ApplicationRecord.transaction do
        item_status_obj.add_buyer(transact_params[:buyer_details])
        byebug
        item_status_obj.transact(TransactionObj.new(transact_params[:transaction]), Utils::TransactionUtils.derive_transaction(transact_params[:transaction_type]).new(transact_params[:transaction_type_details]))
      end
    end

    def update_share(share_type, share)
      item_status_obj.update_share(share_type, share)
    end

    def model
      raise "This is an abstract class"
    end

    def model_name
      raise "This is an abstract class"
    end

    def distributor
      distributor_record = record.distributor
      return nil if distributor_record.blank?
      BusinessLogic::DistributorObj.new(distributor_record)
    end

    def agency
      agency_record = record.agency
      return nil if agency_record.blank?
      BusinessLogic::AgencyObj.new(agency_record)
    end

    private

    def create_record(params)
      record.save!
    end

    def update(params)
      record.update(params)
    end

  end
end
