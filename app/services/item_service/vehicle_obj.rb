module ItemService
  class VehicleObj < ItemObj

    def model_name
      "Vehicle"
    end

    def model
      Vehicle.includes(:item_status)
    end

  end
end
