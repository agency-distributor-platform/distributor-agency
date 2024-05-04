require_relative "./migration_utils.rb"

class CreateInquiries < ActiveRecord::Migration[7.0]

  include MigrationUtils

  TABLE_NAME = :inquiries

  def up
    create_table TABLE_NAME do |t|
      t.string :vehicle_model
      t.float :starting_price
      t.float :ending_price
      t.text :comments
      t.integer :year
      t.timestamps
    end
  end

  def down
    delete_table TABLE_NAME
  end

end
