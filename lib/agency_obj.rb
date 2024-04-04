require_relative "./vehicle_obj"

module BusinessLogic
  class AgencyObj

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

    def get_item(item_details)
      item_type = item_details[:item_type]
      item_id = item_details[:item_id]
      derive_model(item_type).find_by(id: item_id).as_json if ItemMapping.where({agency_id: record_id, item_type: , item_id: }).present?
    end

    def record_id
      record.id
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

  end
end
