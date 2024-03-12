require_relative "./migration_utils.rb"

class AddPersonaIdToMappings < ActiveRecord::Migration[7.0]
  include MigrationUtils
  REFERENCE_TABLE = :personas
  SOURCE_TABLE = :item_selling_records
  COLUMN_NAME = :seller_persona_id

  def up
    add_with_verification_column(SOURCE_TABLE, COLUMN_NAME, :bigint)
    add_foreign_key_column(SOURCE_TABLE, REFERENCE_TABLE, COLUMN_NAME)
  end

  def down
    remove_foreign_key_column(SOURCE_TABLE, REFERENCE_TABLE)
    remove_with_verification_column(SOURCE_TABLE, COLUMN_NAME)
  end
end
