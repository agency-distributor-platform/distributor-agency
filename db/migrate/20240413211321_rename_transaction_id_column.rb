require_relative "./migration_utils.rb"

class RenameTransactionIdColumn < ActiveRecord::Migration[7.0]

  include MigrationUtils

  TABLE_NAME = :transactions
  OLD_COLUMN_NAME = :transaction_id
  NEW_COLUMN_NAME = :payment_transaction_id

  def up
    rename_column_with_verification(TABLE_NAME, OLD_COLUMN_NAME, NEW_COLUMN_NAME)
    alter_column_datatype_with_verification(TABLE_NAME, NEW_COLUMN_NAME, :string)
  end

  def down
    rename_column_with_verification(TABLE_NAME, NEW_COLUMN_NAME, OLD_COLUMN_NAME)
    alter_column_datatype_with_verification(TABLE_NAME, OLD_COLUMN_NAME, :bigint)
  end
end
