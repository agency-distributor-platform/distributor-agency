require_relative "./migration_utils.rb"

class CreateVehicleModels < ActiveRecord::Migration[7.0]

  include MigrationUtils
  TABLE_NAME = :vehicle_models

  def up
    return if table_exists? TABLE_NAME
    create_table TABLE_NAME do |t|
      t.string :company_name
      t.string :model
      t.timestamps
    end
  end

  def down
    delete_table TABLE_NAME
  end
end
