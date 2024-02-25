require_relative "./migration_utils.rb"

class ShiftCostPriceDetailsToVehiclesTable < ActiveRecord::Migration[7.0]

  include MigrationUtils
  SOURCE_TABLE = :item_selling_records
  DESTINATION_TABLE = :vehicles
  SHIFTING_COLUMNS = [{column_name: :cost_price, datatype: :float}, {column_name: :cost_price_visibility_status, datatype: :string}]
  REMOVAL_SOURCE_COLUMNS = [{column_name: :selling_user_id, datatype: :bigint}]
  ADD_SOURCE_COLUMNS = [{column_name: :distributor_id, datatype: :bigint}]
  ADD_DESTINATION_COLUMNS = [{column_name: :status, datatype: :string}]

  def up
    SHIFTING_COLUMNS.each { |column|
      remove_with_verification_column(SOURCE_TABLE, column[:column_name])
      add_with_verification_column(DESTINATION_TABLE, column[:column_name], column[:datatype])
    }
    REMOVAL_SOURCE_COLUMNS.each { |column|
      remove_with_verification_column(SOURCE_TABLE, column[:column_name])
    }
    ADD_SOURCE_COLUMNS.each { |column|
      add_with_verification_column(SOURCE_TABLE, column[:column_name], column[:datatype])
    }
    ADD_DESTINATION_COLUMNS.each { |column|
      add_with_verification_column(DESTINATION_TABLE, column[:column_name], column[:datatype])
    }
  end

  def down
    SHIFTING_COLUMNS.each { |column|
      remove_with_verification_column(DESTINATION_TABLE, column[:column_name])
      add_with_verification_column(SOURCE_TABLE, column[:column_name], column[:datatype])
    }
    ADD_SOURCE_COLUMNS.each { |column|
      remove_with_verification_column(SOURCE_TABLE, column[:column_name])
    }
    REMOVAL_SOURCE_COLUMNS.each { |column|
      add_with_verification_column(SOURCE_TABLE, column[:column_name], column[:datatype])
    }
    ADD_DESTINATION_COLUMNS.each { |column|
      remove_with_verification_column(DESTINATION_TABLE, column[:column_name])
    }
  end
end
