require_relative "./migration_utils.rb"

class AddManufactoringYearToVehicle < ActiveRecord::Migration[7.0]

  include MigrationUtils
  TABLE_NAME = :vehicle_models
  def up
    add_with_verification_column(TABLE_NAME, :manufactoring_year, :integer)
  end

  def down
    remove_with_verification_column(TABLE_NAME, :manufactoring_year)
  end
end
