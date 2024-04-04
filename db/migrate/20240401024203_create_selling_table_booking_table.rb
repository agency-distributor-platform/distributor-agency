require_relative "./migration_utils.rb"

class CreateSellingTableBookingTable < ActiveRecord::Migration[7.0]

  include MigrationUtils
  TABLE_NAMES = [:selling_transactions, :booking_transactions]

  def up
    return if table_exists? TABLE_NAMES.first
    create_table TABLE_NAMES.first do |t|
      t.float  :selling_price
      t.float  :due_price
      t.string :selling_persona_type
    end

    return if table_exists? TABLE_NAMES.second
    create_table TABLE_NAMES.second do |t|
      t.float  :booking_price
      t.string :booking_persona_type
    end
  end

  def down
    delete_table TABLE_NAMES.first
    delete_table TABLE_NAMES.second
  end
end
