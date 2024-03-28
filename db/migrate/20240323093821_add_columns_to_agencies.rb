require_relative "./migration_utils.rb"

class AddColumnsToAgencies < ActiveRecord::Migration[7.0]

  include MigrationUtils
  TABLE_NAME = :agencies
  ADD_COLUMNS = {:city => :string, :state => :string, :pincode => :integer}

  def up
    ADD_COLUMNS.each { |column, datatype|
      add_with_verification_column(TABLE_NAME, column, datatype)
    }
  end

  def down
    ADD_COLUMNS.each { |column, datatype|
      remove_with_verification_column(TABLE_NAME, column, datatype)
    }
  end
end
