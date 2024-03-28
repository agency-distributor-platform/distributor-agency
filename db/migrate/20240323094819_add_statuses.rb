require_relative "./migration_utils.rb"

class AddStatuses < ActiveRecord::Migration[7.0]

  include MigrationUtils
  TABLE_NAME = :statuses
  SECOND_TABLE_NAME = :item_selling_records
  FOREIGN_KEY_COLUMN_NAME = :status_id

  def up
    return if table_exists? TABLE_NAME
    create_table TABLE_NAME do |t|
      t.string :name
    end

    add_with_verification_column(SECOND_TABLE_NAME, FOREIGN_KEY_COLUMN_NAME, :bigint)
    add_foreign_key_column(SECOND_TABLE_NAME, TABLE_NAME, FOREIGN_KEY_COLUMN_NAME)
  end

  def down
    remove_with_verification_column(SECOND_TABLE_NAME, FOREIGN_KEY_COLUMN_NAME)
    delete_table TABLE_NAME
  end
end
