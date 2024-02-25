require_relative "./migration_utils.rb"

class CreateUsers < ActiveRecord::Migration[7.0]
  TABLE_NAME = :users
  def up
    return if table_exists? TABLE_NAME
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :item_type
      t.bigint :item_id
      t.timestamps
    end
  end

  def down
    delete_table TABLE_NAME
  end
end
