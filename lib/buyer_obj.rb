module BusinessLogic
  class BuyerObj

    attr_accessor :record

    def initialize(record)
      @record = record[:id].present? ? Buyer.find_by(id: record[:id]) : Buyer.new(record)
    end

    def create_or_update(buyer_details)
      record.update(buyer_details)
    end

    def record_id
      record.id
    end

  end
end
