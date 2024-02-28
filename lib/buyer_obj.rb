module BusinessLogic
  class BuyerObj

    attr_accessor :record

    def initialize(record)
      @record = record[:id].present? ? Buyer.find_by(id: record[:id]) : Buyer.new(record)
    end

    def create_or_update(buyer_details)
      if record.persisted?
        record.update(buyer_details)
      else
        record.save!
      end
    end

    def record_id
      record.id
    end

  end
end
