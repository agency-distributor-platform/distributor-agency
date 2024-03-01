module BusinessLogic
  class DistributorObj

    attr_accessor :record

    def initialize(record)
      @record = record[:id].present? ? Distributor.find_by(id: record[:id]) : Distributor.new(record)
    end

    def link_to_agency(agency_obj)
      if record_present?
        return if agency_obj.distributors.pluck(:id).include?(record_id)
        record.distributor = agency_obj.record
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
      record.id.present?
    end

    def record_id
      record.id
    end

  end
end
