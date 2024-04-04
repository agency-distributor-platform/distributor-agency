require_relative "./migration_utils.rb"

class EditSalespersons < ActiveRecord::Migration[7.0]
  include MigrationUtils
  TABLE_NAME = :salespersons
  ADD_COLUMNS = {:address => :text, :city => :string, :state => :string, :pincode => :integer}

  def up
    ADD_COLUMNS.each { |column, datatype|
      add_with_verification_column(TABLE_NAME, column, datatype)
    }
    remove_with_verification_column(TABLE_NAME, :location)
  end

  def down
    ADD_COLUMNS.each { |column, datatype|
      remove_with_verification_column(TABLE_NAME, column, datatype)
    }
    add_with_verification_column(TABLE_NAME, :location, :string)
  end
end
