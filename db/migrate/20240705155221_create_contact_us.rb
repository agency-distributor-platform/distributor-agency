require_relative "./migration_utils.rb"
class CreateContactUs < ActiveRecord::Migration[7.0]
  TABLE_NAME = :contact_us
  include MigrationUtils
  def up
    return if table_exists?(TABLE_NAME)
    create_table TABLE_NAME do |t|
      t.string :name
      t.string :email
      t.bigint :phone
      t.text :message

      t.timestamps
    end

    def down
      if table_exists?(TABLE_NAME)
        delete_table TABLE_NAME
      end
    end
  end
end
