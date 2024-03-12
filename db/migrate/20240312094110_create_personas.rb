require_relative "./migration_utils.rb"

class CreatePersonas < ActiveRecord::Migration[7.0]
  include MigrationUtils
  TABLE_NAME = :personas
  def up
    return if table_exists? TABLE_NAME
    create_table TABLE_NAME do |t|
      t.string :persona_name
      t.timestamps
    end

  end

  def down
    delete_table(TABLE_NAME)
  end
end
