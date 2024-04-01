require_relative "./migration_utils.rb"

class CreateSessionsTable < ActiveRecord::Migration[7.0]

  include MigrationUtils
  TABLE_NAME = :sessions_tables

  def up
    return if table_exists?(TABLE_NAME)
    create_table TABLE_NAME do |t|
      t.string :session_id
      t.timestamps
    end
    add_index_to_columns(TABLE_NAME, [:session_id], {unique: true})

  end

  def down
    delete_table TABLE_NAME
  end
end
