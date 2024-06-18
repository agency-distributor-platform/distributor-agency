class AddKmsDrivenToVehicles < ActiveRecord::Migration[7.0]
  def change
    add_column :vehicles, :kms_driven, :bigint
  end
end
