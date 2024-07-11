require_relative "./migration_utils.rb"
class AddCategoryToVehicles < ActiveRecord::Migration[7.0]
  include MigrationUtils
  TABLE_NAME = :vehicles
  COLUMN_NAME = :category
  def up
    allowed_values = ['2 Wheeler', '3 Wheeler' ,'4 Wheeler' , 'Farm Equipment', 'Commerical']
    add_enum_column_with_verification(TABLE_NAME, COLUMN_NAME, allowed_values)
  end

  def down 
    remove_with_verification_column(TABLE_NAME, COLUMN_NAME)
  end 
end
