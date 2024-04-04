require_relative "./migration_utils.rb"

class AddUniqueKeyToVehicleModels < ActiveRecord::Migration[7.0]
  include MigrationUtils
  TABLE_NAME = :vehicle_models
  COLUMNS = [:company_name, :model]

  def up
    add_index_to_columns(TABLE_NAME, COLUMNS, {name: index_name, unique: true})
  end

  def down
    remove_index_with_verification(TABLE_NAME, index_name)
  end

  private


  def index_name
    "#{TABLE_NAME}_unique_#{COLUMNS.first}_#{COLUMNS.second}"
  end
end
