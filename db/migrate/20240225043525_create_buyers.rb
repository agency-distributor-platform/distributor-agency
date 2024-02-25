require_relative "./migration_utils.rb"

class CreateBuyers < ActiveRecord::Migration[7.0]
  TABLE_NAME = :buyers
  include MigrationUtils
  def up
    return if table_exists? TABLE_NAME
    create_table TABLE_NAME do |t|
      t.string :name
      t.text :user_metadata #will normalise on getting more details in later migrations
      t.timestamps
    end
  end

  def down
    delete_table TABLE_NAME
  end
end
