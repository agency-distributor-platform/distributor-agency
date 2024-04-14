module ItemService
  class TransactionObj

    attr_reader :record

    def initialize(params)
      @record = params[:id].present? ? Transaction.find_by(id: params[:id]) : Transaction.new(params)
    end

    def create_record(item_status_obj)
      record.item_status = item_status_obj.record
      record.save!
    end

    def transaction_date
      record.transaction_date
    end

    def previous_transaction(transaction_type)
      #TO-DO: Return a selling_transaction_object instance instead of a selling_transaction_strategy instance
      selling_transaction_record = record.item_status.send(transaction_type).order(id: :desc).limit(1).first
      return TransactionStrategy::SellingTransactionStrategy.new(selling_transaction_record, true) if selling_transaction_record.present?
      selling_transaction_record
    end

    def item_status_obj
      ItemService::ItemStatusObj.new(record.item_status)
    end

  end
end
