require_relative "./migration_utils.rb"
class AddKmsDrivenToVehicles < ActiveRecord::Migration[7.0]
  include MigrationUtils
  TABLE_NAME = :vehicles
  def change
    add_with_verification_column(TABLE_NAME, :kms_driven, :bigint)
  end
end