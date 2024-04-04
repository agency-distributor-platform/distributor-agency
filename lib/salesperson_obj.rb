module BusinessLogic
  class SalespersonObj

    attr_accessor :record
    def initialize(record)
      @record = record[:id].present? ? Salesperson.find_by(id: record[:id]) : Salesperson.new(record)
    end

    def update(params)
      record.update(params)
    end

    def record_id
      record.id
    end

    private

    def derive_model(item_type)
      "#{item_type.capitalize}".constantize
    end

  end
end
