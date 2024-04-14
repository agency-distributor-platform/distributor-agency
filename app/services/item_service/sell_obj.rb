module ItemService
  class SellObj

    attr_reader :record, :transaction_obj

    def initialize(params)
      @record = params[:id].present? ? SellingTransaction.find_by(id: params[:id]) : SellingTransaction.new(params)
      @transaction_obj = TransactionObj.new(record.transaction_record) if params[:id].present?
    end

    def as_json
      record_as_json = record.as_json
      previous_selling_transaction = transaction_obj.previous_transaction("selling_transactions")
      current_due_amount = record_as_json.delete("due_price")
      if previous_selling_transaction.blank?
        record_as_json["paid_amount"] = record_as_json["selling_price"] - current_due_amount
      else
        #TO-DO: Use current class to get due amount
        previous_due_amount = previous_selling_transaction.due_price
        record_as_json["paid_amount"] = previous_due_amount - current_due_amount
      end
      record_as_json
    end

  end
end
