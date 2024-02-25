require_relative "./migration_utils.rb"

class AddUniqueRegistrationId < ActiveRecord::Migration[7.0]
  include MigrationUtils
  TABLE_NAME = :vehicles
  COLUMNS = [:registration_id, :chassis_id, :engine_id]
  def up
    COLUMNS.each { |column|
      add_index_to_columns(TABLE_NAME, column, {name: index_name(column)})
    }
  end

  def down
    COLUMNS.each { |column|
      remove_index_with_verification(TABLE_NAME, index_name(column))
    }
  end

  private

  def index_name(column)
    "#{TABLE_NAME}_unique_#{column}"
  end
end
