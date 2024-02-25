require_relative "./migration_utils.rb"

class AddForeignKeyToItemSellingRecords < ActiveRecord::Migration[7.0]

  include MigrationUtils
  SOURCE_TABLE = :item_selling_records
  REFERENCE_TABLE = :distributors
  REFERENCE_COLUMN = :distributor_id

  def up
    add_foreign_key_column(SOURCE_TABLE, REFERENCE_TABLE, REFERENCE_COLUMN)
  end

  def down
    remove_foreign_key_column(SOURCE_TABLE, REFERENCE_COLUMN)
  end
end
