require_relative "./migration_utils.rb"

class AddAgencyIdToInquireis < ActiveRecord::Migration[7.0]

  include MigrationUtils
  TABLE_NAME = :inquiries
  COLUMN_NAME = :agency_id

  def up
    add_with_verification_column(TABLE_NAME, COLUMN_NAME, :bigint)
    add_foreign_key_column(TABLE_NAME, :agencies, COLUMN_NAME)
  end

  def down
    remove_with_verification_column(TABLE_NAME, COLUMN_NAME)
  end
end
