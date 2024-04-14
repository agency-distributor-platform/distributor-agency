module ItemService
  class BookObj

    attr_reader :record

    def initialize(params)
      @record = params[:id].present? ? BookingTransaction.find_by(id: params[:id]) : BookingTransaction.new(params)
    end

    def as_json
      record.as_json
    end

  end
end
