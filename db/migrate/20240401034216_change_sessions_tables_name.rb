require_relative "./migration_utils.rb"

class ChangeSessionsTablesName < ActiveRecord::Migration[7.0]

  include MigrationUtils

  def up
    rename_table_with_verification(:sessions_tables, :sessions)
  end

  def down
    rename_table_with_verification(:sessions, :sessions_tables)
  end
end
