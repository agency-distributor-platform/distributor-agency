require_relative "./migration_utils.rb"

class DeleteDuplicateColumnsInItemMappingTable < ActiveRecord::Migration[7.0]
  include MigrationUtils
  FIRST_TABLE_NAME = :item_mapping_records
  FIRST_TABLE_REMOVE_COLUMNS = {:seller_persona_id => :bigint}

  SECOND_TABLE_NAME = :vehicles
  SECOND_TABLE_REMOVE_COLUMNS = {:selling_price => :float, :cost_price_visibility_status => :boolean, :selling_price_visibility_status => :string}
  def up
    FIRST_TABLE_REMOVE_COLUMNS.each { |column, datatype|
      remove_with_verification_column(FIRST_TABLE_NAME, column)
    }

    SECOND_TABLE_REMOVE_COLUMNS.each { |column, datatype|
      remove_with_verification_column(SECOND_TABLE_NAME, column)
    }
  end

  def down
    FIRST_TABLE_REMOVE_COLUMNS.each { |column, datatype|
      add_with_verification_column(FIRST_TABLE_NAME, column, datatype)
    }

    SECOND_TABLE_REMOVE_COLUMNS.each { |column, datatype|
      add_with_verification_column(SECOND_TABLE_NAME, column, datatype)
    }
  end
end
