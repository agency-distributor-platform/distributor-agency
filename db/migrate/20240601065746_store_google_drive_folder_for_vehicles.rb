require_relative "./migration_utils.rb"

class StoreGoogleDriveFolderForVehicles < ActiveRecord::Migration[7.0]

  include MigrationUtils
  TABLE_NAME = :vehicles
  COLUMN_NAME = :google_drive_folder_id

  def up
    add_with_verification_column(TABLE_NAME, COLUMN_NAME, :string)
  end

  def down
    remove_with_verification_column(TABLE_NAME, COLUMN_NAME)
  end
end
