module ItemService
  module TransactionStrategy
    class SellingTransactionStrategy < BaseTransactionStrategy

      ELIGIBLE_PERSONAS = ["Agency", "Distributor", "Salesperson"]

      attr_reader :paid_amount, :selling_price

      def initialize(params, db_record=false)
        if !db_record
          @paid_amount = params.delete(:paid_amount)
          @selling_price = params[:selling_price]
          @persona_type = params[:selling_persona_type]
        end
        @record = params[:id].present? ? model.find_by(id: params[:id]) : model.new(params)
        if db_record
          @paid_amount = record.selling_price - record.due_price
          @selling_price = record.selling_price
          @persona_type = record.selling_persona_type
        end
      end

      def implement
        super
        previous_selling_transaction = transaction_obj.latest_recorded_transaction("selling_transactions")
        previous_booking_transaction = transaction_obj.latest_recorded_transaction("booking_transactions")
        raise "Can't have new selling price for partially paid product. Please edit the selling price separately" if selling_price.present? && previous_selling_transaction.present?
        if selling_price.blank?
          if previous_selling_transaction.present?
            previous_transaction_prices = previous_selling_transaction.get_prices
            @selling_price = previous_transaction_prices[:selling_price]
            due_price = previous_transaction_prices[:due_price] - paid_amount
          else
          end
        else
          booking_price = previous_booking_transaction.present? ? previous_booking_transaction.get_prices[:booking_price] : 0
          due_price = selling_price - (paid_amount + booking_price)
        end
        raise "Paid amount exceeds selling price" if due_price < 0
        create_record(selling_price, due_price)
        update_status_of_item(due_price)
      end

      protected

      def get_prices
        {
          selling_price: record.selling_price,
          due_price: record.due_price
        }
      end

      private

      def model
        SellingTransaction
      end

      def create_record(selling_price, due_price)
        record.selling_price = selling_price
        record.due_price = due_price
        record.selling_persona_type = persona_type
        link_transaction
        record.save!
      end

      def update_status_of_item(due_price)
        due_price.zero? ? item_status_obj.update_status(Status.find_by(name: "Sold")) : item_status_obj.update_status(Status.find_by(name: "Sold with due amount"))
      end

    end
  end
end
