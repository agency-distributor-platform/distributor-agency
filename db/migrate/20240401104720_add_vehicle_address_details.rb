require_relative "./migration_utils.rb"

class AddVehicleAddressDetails < ActiveRecord::Migration[7.0]

  include MigrationUtils
  TABLE_NAME = :vehicles
  COLUMNS = {
    city: :string,
    state: :string,
    pincode: :integer
  }

  REMOVE_COLUMNS = {
    status: :string
  }

  def up
    COLUMNS.each { |column_name, datatype|
      add_with_verification_column(TABLE_NAME, column_name, datatype)
    }

    REMOVE_COLUMNS.each { |column_name, _datatype|
      remove_with_verification_column(TABLE_NAME, column_name)
    }
  end

  def down
    REMOVE_COLUMNS.each { |column_name, datatype|
      add_with_verification_column(TABLE_NAME, column_name, datatype)
    }

    COLUMNS.each { |column_name, _datatype|
      remove_with_verification_column(TABLE_NAME, column_name)
    }
  end
end
