require_relative "./migration_utils.rb"

class RenameUserPolymorphicColumns < ActiveRecord::Migration[7.0]
  include MigrationUtils
  TABLE_NAME = :users
  OLD_COLUMN_NAMES = [:item_type, :item_id]
  NEW_COLUMN_NAMES = [:employer_type, :employer_id]

  def up
    OLD_COLUMN_NAMES.each_with_index { |column, index|
      rename_column(TABLE_NAME, column, NEW_COLUMN_NAMES[index])
    }
  end

  def down
    OLD_COLUMN_NAMES.each_with_index { |column, index|
      rename_column(TABLE_NAME, NEW_COLUMN_NAMES[index], column)
    }
  end
end
