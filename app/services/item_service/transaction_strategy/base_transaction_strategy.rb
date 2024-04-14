module ItemService
  module TransactionStrategy
    class BaseTransactionStrategy

      attr_reader :record, :transaction_details, :transaction_obj, :item_status_obj, :persona_type

      def set_transaction_obj(transaction_obj)
        @transaction_obj = transaction_obj
        @item_status_obj = transaction_obj.item_status_obj
      end

      def implement
        verify_selling_persona
      end

      private

      def model
        raise "This is abstract class"
      end

      def link_transaction
        record.transaction_record = transaction_obj.record
        record.save!
      end

      def verify_selling_persona
        return if persona_type == "Agency"
        raise "Wrong persona" if !transaction_obj.has_distributor_assigned? && persona_type == "Distributor"
        raise "Wrong persona" if !transaction_obj.has_salesperson_assigned? && persona_type == "Salesperson"
        raise "Invalid value for persona" if !ELIGIBLE_PERSONAS.include?(persona_type)
      end

    end
  end
end
