require_relative "./migration_utils.rb"
class CreateAddOn < ActiveRecord::Migration[7.0]
  TABLE_NAME = :add_ons
  include MigrationUtils
  def up
    return if table_exists?(TABLE_NAME)
    create_table :add_ons do |t|
      t.float :amount
      t.string :user_name
      t.text :description
      t.string :garage_name
      t.string :location
      t.bigint :item_mapping_record_id

      t.timestamps
    end
    add_foreign_key_column(TABLE_NAME, :item_mapping_records, :item_mapping_record_id)
  end

  def down
    delete_table TABLE_NAME
  end
end
