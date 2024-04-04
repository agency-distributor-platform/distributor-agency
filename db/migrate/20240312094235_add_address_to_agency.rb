require_relative "./migration_utils.rb"

class AddAddressToAgency < ActiveRecord::Migration[7.0]
  include MigrationUtils
  COLUMN_NAME = :address
  TABLE_NAME = :agencies
  DATA_TYPE = :text

  def up
    add_with_verification_column(TABLE_NAME, COLUMN_NAME, DATA_TYPE)
  end

  def down
    remove_with_verification_column(TABLE_NAME, COLUMN_NAME)
  end
end
