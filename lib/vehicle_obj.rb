require_relative "./item_obj.rb"

module BusinessLogic
  class VehicleObj < ItemObj

    attr_accessor :record

    def create_or_update(data, agency_id)
      record.cost_price_visibility_status = false if data[:cost_price_visibility_status].blank?
      record.selling_price_visibility_status = false if data[:selling_price_visibility_status].blank?
      super(data, agency_id)
    end

    private

    def model
      Vehicle
    end
  end
end
