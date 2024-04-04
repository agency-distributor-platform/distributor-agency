require_relative "./migration_utils.rb"

class RemovePersonas < ActiveRecord::Migration[7.0]
  include MigrationUtils
  TABLE_NAME = :personas
  def up
    delete_table(TABLE_NAME)
  end

  def down
    return if table_exists? TABLE_NAME
    create_table TABLE_NAME do |t|
      t.string :persona_name
      t.timestamps
    end

  end

end
