require_relative "./migration_utils.rb"

class CreateTransactions < ActiveRecord::Migration[7.0]

  TABLE_NAME = :transactions
  include MigrationUtils

  def up
    return if table_exists?(TABLE_NAME)
    create_table :transactions do |t|
      t.bigint :item_mapping_record_id
      t.datetime :selling_date
      t.datetime :booking_date
      t.datetime :downpayment_date
      t.string :seller_persona_type
      t.string :booking_persona_type
      t.string :partial_seller_persona_type
      t.float :selling_price
      t.float :booking_price
      t.float :due_price
      t.datetime :transaction_date
    end
    add_foreign_key_column(TABLE_NAME, :item_mapping_records, :item_mapping_record_id)
  end

  def down
    delete_table TABLE_NAME
  end
end
