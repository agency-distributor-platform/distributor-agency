require_relative "./migration_utils.rb"

class CreateVehicles < ActiveRecord::Migration[7.0]
  include MigrationUtils
  TABLE_NAME = :vehicles

  def up
    return if table_exists? TABLE_NAME
    create_table TABLE_NAME do |t|
      t.bigint :vehicle_model_id
      t.string :registration_id
      t.string :chassis_id
      t.string :engine_id
      t.integer :manufacturing_year
      t.timestamps
    end
    add_foreign_key_column(TABLE_NAME, :vehicle_models, :vehicle_model_id)
  end

  def down
    delete_table TABLE_NAME
  end
end
