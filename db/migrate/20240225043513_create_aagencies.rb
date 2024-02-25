require_relative "./migration_utils.rb"

class CreateAagencies < ActiveRecord::Migration[7.0]
  include MigrationUtils
  TABLE_NAME = :agencies

  def up
    create_table TABLE_NAME do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :uuid
      t.timestamps
    end
  end

  def down
    delete_table(TABLE_NAME)
  end
end
