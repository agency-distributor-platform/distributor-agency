require_relative "./migration_utils.rb"

class AddSalespersonIdToItemMappingRecords < ActiveRecord::Migration[7.0]

  include MigrationUtils
  TABLE_NAME = :item_mapping_records

  def up
    add_with_verification_column(TABLE_NAME, :salesperson_id, :bigint)
    add_with_verification_column(TABLE_NAME, :salesperson_share, :integer)
    add_with_verification_column(TABLE_NAME, :distributor_share, :integer)
  end

  def down
    remove_with_verification_column(TABLE_NAME, :salesperson_id)
    remove_with_verification_column(TABLE_NAME, :salesperson_share)
    remove_with_verification_column(TABLE_NAME, :distributor_share)
  end
end
