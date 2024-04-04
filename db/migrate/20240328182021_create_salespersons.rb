require_relative "./migration_utils.rb"

class CreateSalespersons < ActiveRecord::Migration[7.0]

  include MigrationUtils

  TABLE_NAME = :salespersons

  def up
    return if table_exists? TABLE_NAME
    create_table TABLE_NAME do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :location
      t.timestamps
    end
  end

  def down
    delete_table TABLE_NAME
  end
end
