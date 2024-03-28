require_relative "./migration_utils.rb"

class CreateProspectUsers < ActiveRecord::Migration[7.0]
  include MigrationUtils
  TABLE_NAME = :prospect_users

  def up
    return if table_exists? TABLE_NAME
    create_table TABLE_NAME do |t|
      t.string :mode
      t.bigint :vehicle_model_id
      t.integer :manufactoring_year
      t.text :comments
      t.string :name
      t.string :email
      t.string :phone
      t.string :refer_persona_type
      t.bigint :refer_persona_id
      t.timestamps
    end
    add_foreign_key_column(TABLE_NAME, :vehicle_models, :vehicle_model_id)
  end

  def down
    delete_table TABLE_NAME
  end

end
