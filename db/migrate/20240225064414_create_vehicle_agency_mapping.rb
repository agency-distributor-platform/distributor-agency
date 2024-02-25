require_relative "./migration_utils.rb"

class CreateVehicleAgencyMapping < ActiveRecord::Migration[7.0]
  SOURCE_TABLE = :vehicles
  REFERENCE_TABLE = :agencies
  FOREIGN_KEY_COLUMN = :agency_id
  DATATYPE = :bigint
  include MigrationUtils

  def up
    add_with_verification_column(SOURCE_TABLE, FOREIGN_KEY_COLUMN, DATATYPE)
    add_foreign_key_column(SOURCE_TABLE, REFERENCE_TABLE, FOREIGN_KEY_COLUMN)
  end

  def down
    remove_with_verification_column(SOURCE_TABLE, FOREIGN_KEY_COLUMN)
  end
end
