require_relative "./migration_utils.rb"

class AddColumnsToBuyers < ActiveRecord::Migration[7.0]

  include MigrationUtils
  TABLE_NAME = :buyers
  ADD_COLUMNS = {:address => :text, :city => :string, :state => :string, :pincode => :integer, addhar: :string, pan: :string, father_name: :string, mother_name: :string}

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
