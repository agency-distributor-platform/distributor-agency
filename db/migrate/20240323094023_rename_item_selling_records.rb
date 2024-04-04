require_relative "./migration_utils.rb"

class RenameItemSellingRecords < ActiveRecord::Migration[7.0]
  include MigrationUtils
  def up
    rename_table_with_verification(old_table_name, new_table_name)
  end

  def down
    rename_table_with_verification(new_table_name, old_table_name)
  end

  private

  def old_table_name
    "item_selling_records"
  end

  def new_table_name
    "item_mapping_records"
  end
end
