require_relative "./migration_utils.rb"

class AddDistributorEmailPhone < ActiveRecord::Migration[7.0]
  include MigrationUtils
  TABLE_NAME = :distributors
  COLUMNS = [{column_name: :email, datatype: :string}, {column_name: :phone, datatype: :string}]

  def up
    COLUMNS.each { |column|
      add_with_verification_column(TABLE_NAME, column[:column_name], column[:datatype])
    }
  end

  def down
    COLUMNS.each { |column|
      remove_with_verification_column(TABLE_NAME, column[:column_name])
    }
  end
end
