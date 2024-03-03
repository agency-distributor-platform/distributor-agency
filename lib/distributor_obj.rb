module BusinessLogic
  class DistributorObj

    attr_accessor :record

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

    def get_sold_items(item_type, limit, page_number)
      offset = page_number*limit + 1 #page number is received, we get db offset
      item_obj_class = derive_item_obj_class(item_type)
      item_obj_class.get_sold_items(ItemMapping.eager_load(:distributor).eager_load(:agency).where(distributor_id: record_id).where(item_type: ), limit, offset)
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

    def get_items(item_type)
      ItemMapping.where({distributor_id: record_id, item_type: }).as_json
    end

    def get_item(item_details)
      item_type = item_details[:item_type]
      item_id = item_details[:item_id]
      ItemMapping.where({distributor_id: record_id, item_type: , item_id: }).first.as_json
    end

    def get_items(item_type)
      item_ids = ItemMapping.where({distributor_id: record_id, item_type: }).pluck(:item_id)
      derive_model(item_type).where(id: item_ids).as_json
    end

    def get_item(item_details)
      item_type = item_details[:item_type]
      item_id = item_details[:item_id]
      derive_model(item_type).find_by(id: item_id).as_json if ItemMapping.where({distributor_id: record_id, item_type: , item_id: }).present?
    end

    private

    def valid_buyer(buyer_id)
      record.item_mappings.pluck(:buyer_id).include?(buyer_id)
    end

    def derive_model(item_type)
      "#{item_type.capitalize}".constantize
    end

  end
end
