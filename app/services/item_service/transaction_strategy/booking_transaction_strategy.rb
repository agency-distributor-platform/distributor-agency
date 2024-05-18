module ItemService
  module TransactionStrategy
    class BookingTransactionStrategy < BaseTransactionStrategy

      def initialize(params)
        @record = params[:id].present? ? model.find_by(id: params[:id]) : model.new(params)
        params.delete(:id)
        @persona_type = params[:booking_persona_type]
      end

      def implement
        super
        ApplicationRecord.transaction {
          item_status_obj.update_status(Status.find_by(name: "Booked")) if within_two_weeks?(transaction_obj.transaction_date)
          create_record
        }
      end

      def get_prices
        {
          booking_price: record.booking_price
        }
      end

      private

      def model
        BookingTransaction
      end

      def create_record
        link_transaction
        record.save!
      end

      def within_two_weeks?(transaction_date)
        transaction_date = DateTime.new(transaction_date.year, transaction_date.month, transaction_date.day)
        difference_in_days = (DateTime.now - transaction_date).to_i.abs
        difference_in_days <= 14
      end

    end
  end
end
