require_relative "./migration_utils.rb"

class EditTransactionsTable < ActiveRecord::Migration[7.0]

  include MigrationUtils
  TABLE_NAME = :transactions
  REMOVAL_COLUMNS = {
    :selling_date => :datetime,
    :booking_date => :datetime,
    :downpayment_date => :datetime,
    :seller_persona_type => :string,
    :booking_persona_type => :string,
    :partial_seller_persona_type => :string,
    :selling_price => :float,
    :booking_price => :float,
    :due_price => :float
  }

  ADD_COLUMNS = {
    :transaction_type => :string,
    :transaction_id => :bigint
  }

  def up
    REMOVAL_COLUMNS.each { |column, _datatype|
      remove_with_verification_column(TABLE_NAME, column)
    }

    ADD_COLUMNS.each { |column, datatype|
      add_with_verification_column(TABLE_NAME, column, datatype)
    }
  end

  def down
    ADD_COLUMNS.each { |column, _datatype|
      remove_with_verification_column(TABLE_NAME, column)
    }

    REMOVE_COLUMNS.each { |column, datatype|
      add_with_verification_column(TABLE_NAME, column, datatype)
    }
  end
end
