class ChangeCostPriceVisibilityStatusToBoolean < ActiveRecord::Migration[7.0]

  TABLE_NAME = :vehicles
  COLUMN_NAME = :cost_price_visibility_status

  def up
    change_column(TABLE_NAME, COLUMN_NAME, :boolean)
  end

  def down
    change_column(TABLE_NAME, COLUMN_NAME, :string)
  end
end
