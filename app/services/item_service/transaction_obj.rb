module ItemService
  class TransactionObj

    attr_reader :record

    def initialize(params)
      @record = params[:id].present? ? Transaction.find_by(id: params[:id]) : Transaction.new(params)
    end

    def has_distributor_assigned?
      item_status_obj.distributor.present?
    end

    def has_salesperson_assigned?
      item_status_obj.salesperson.present?
    end

    def create_record(item_status_obj)
      record.item_status = item_status_obj.record
      record.save!
    end

    def transaction_date
      record.transaction_date
    end

    def latest_recorded_transaction(transaction_type)
      #TO-DO: Return a selling_transaction_object instance instead of a selling_transaction_strategy instance
      #TO-DO: record.item_status -> item_status_obj
      selling_transaction_record = record.item_status.send(transaction_type).order(id: :desc).limit(1).first
      return TransactionStrategy::SellingTransactionStrategy.new(selling_transaction_record, true) if selling_transaction_record.present?
      selling_transaction_record
    end

    def previous_transaction(transaction_type)
      selling_transaction_record = item_status_obj.transactions_by_type(transaction_type).order(id: :desc).where("transactions.id < ?", record.id).limit(1).first
      selling_transaction_record if selling_transaction_record.present?
    end

    def get_transaction_details
      #TO-DO: Return a selling_transaction_object instance instead of a selling_transaction_active_record instance
      transaction_details = {}
      ["sell", "book"].each { |transaction_type|
        transaction_details = "ItemService::#{transaction_type.capitalize}Obj".constantize.new(record.send("#{transaction_type}ing_transaction")) rescue next
        if transaction_details.present?
          transaction_details = transaction_details.as_json
          transaction_details[:transaction_type] = transaction_type
          break
        end
      }
      transaction_details
    end

    def as_json
      record.as_json
    end

    def item_status_obj
      ItemService::ItemStatusObj.new(record.item_status)
    end

  end
end
