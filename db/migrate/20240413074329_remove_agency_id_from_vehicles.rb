require_relative "./migration_utils.rb"

class RemoveAgencyIdFromVehicles < ActiveRecord::Migration[7.0]

  include MigrationUtils

  def up
    remove_with_verification_column(:vehicles, :agency_id)
  end

  def down
    add_with_verification_column(:vehicles, :agency_id, :bigint)
    add_foreign_key_column(:vehicles, :agencies, :agency_id)
  end
end
