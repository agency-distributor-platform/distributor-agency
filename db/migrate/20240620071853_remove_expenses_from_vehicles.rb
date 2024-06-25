require_relative "./migration_utils.rb"
class RemoveExpensesFromVehicles < ActiveRecord::Migration[7.0]
  include MigrationUtils
  def up
    remove_with_verification_column(:vehicles, :expenses)
  end

  def down
    add_with_verification_column(:vehicles, :expenses, :float)
  end
end
