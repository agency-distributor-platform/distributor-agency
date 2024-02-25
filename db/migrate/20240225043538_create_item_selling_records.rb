require_relative "./migration_utils.rb"
class CreateItemSellingRecords < ActiveRecord::Migration[7.0]
  include MigrationUtils
  TABLE_NAME = :item_selling_records

  def up
    return if table_exists? TABLE_NAME
    create_table TABLE_NAME do |t|
      t.string :item_type
      t.bigint :item_id
      t.bigint :agency_id
      t.bigint :selling_user_id
      t.bigint :buyer_id
      t.float :selling_price
      t.string :selling_price_visibility_status
      t.float :cost_price
      t.string :cost_price_visibility_status
      t.timestamps
    end
    add_foreign_key_column(TABLE_NAME, :agencies, :agency_id)
    add_foreign_key_column(TABLE_NAME, :users, :selling_user_id)
    add_foreign_key_column(TABLE_NAME, :buyers, :buyer_id)
  end

  def down
    delete_table(TABLE_NAME)
  end

end
