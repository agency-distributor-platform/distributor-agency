require_relative "./migration_utils.rb"
class AddExpensesToItemMappingRecords < ActiveRecord::Migration[7.0]
  include MigrationUtils
  TABLE_NAME = :item_mapping_records
  def up
    add_with_verification_column(TABLE_NAME, :expenses, :float)
  end

  def down
    remove_with_verification_column(TABLE_NAME, :expenses)
  end
end