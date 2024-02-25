require_relative "./migration_utils.rb"

class CreateDistirbutors < ActiveRecord::Migration[7.0]
  include MigrationUtils
  TABLE_NAME = :distributors
  def up
    return if table_exists? TABLE_NAME
    create_table TABLE_NAME do |t|
      t.bigint :agency_id
      t.string :name
      t.text :metadata
      t.timestamps
    end
    add_foreign_key_column(TABLE_NAME, :agencies, :agency_id)

  end

  def down
    delete_table(TABLE_NAME)
  end
end
