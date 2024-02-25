require_relative "./migration_utils.rb"

class ShiftSellingPriceColumns < ActiveRecord::Migration[7.0]
  SOURCE_TABLE = :item_selling_records
  DESTINATION_TABLE = :vehicles
  SHIFTING_COLUMNS = [{column_name: :selling_price, datatype: :float}, {column_name: :selling_price_visibility_status, datatype: :string}]
  include MigrationUtils

  def up
    SHIFTING_COLUMNS.each { |column|
      remove_with_verification_column(SOURCE_TABLE, column[:column_name])
      add_with_verification_column(DESTINATION_TABLE, column[:column_name], column[:datatype])
    }
  end

  def down
    SHIFTING_COLUMNS.each { |column|
      remove_with_verification_column(DESTINATION_TABLE, column[:column_name])
      add_with_verification_column(SOURCE_TABLE, column[:column_name], column[:datatype])
    }
  end
end
