require_relative "./migration_utils.rb"

class AddStatusMapping < ActiveRecord::Migration[7.0]
  REFERENCE_TABLE_NAME = :statuses
  TABLE_NAME = :item_mapping_records
  FOREIGN_KEY_COLUMN_NAME = :status_id
  include MigrationUtils

  def up
    add_with_verification_column(TABLE_NAME, FOREIGN_KEY_COLUMN_NAME, :bigint)
    add_foreign_key_column(TABLE_NAME, REFERENCE_TABLE_NAME, FOREIGN_KEY_COLUMN_NAME)
  end

  def down
    remove_with_verification_column(TABLE_NAME, FOREIGN_KEY_COLUMN_NAME)
  end

end
