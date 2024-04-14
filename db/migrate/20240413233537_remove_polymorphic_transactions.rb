require_relative "./migration_utils.rb"

class RemovePolymorphicTransactions < ActiveRecord::Migration[7.0]

  include MigrationUtils

  def change
    remove_with_verification_column(:transactions, :transaction_type)
    add_with_verification_column(:selling_transactions, :transaction_id, :bigint)
    add_with_verification_column(:booking_transactions, :transaction_id, :bigint)
    add_foreign_key_column(:selling_transactions, :transactions, :transaction_id)
    add_foreign_key_column(:booking_transactions, :transactions, :transaction_id)
  end

  def down
    add_with_verification_column(:transactions, :transaction_type, :string)
    remove_with_verification_column(:selling_transactions, :transaction_id)
    remove_with_verification_column(:booking_transactions, :transaction_id)
  end
end
