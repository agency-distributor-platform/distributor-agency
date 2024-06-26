require_relative "./migration_utils.rb"

class ChangeKmsDrivenDatatype < ActiveRecord::Migration[7.0]

  include MigrationUtils

  TABLE_NAME = :vehicles
  COLUMN_NAME = :expenses

  def up
    alter_column_datatype_with_verification(TABLE_NAME, COLUMN_NAME, :float)
  end

  def down
    alter_column_datatype_with_verification(TABLE_NAME, COLUMN_NAME, :bigint)
  end
end
