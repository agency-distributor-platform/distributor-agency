class AddExpensesAndFinCompanyNameToVehicles < ActiveRecord::Migration[7.0]
  def change
    add_column :vehicles, :expenses, :float
    add_column :vehicles, :fin_company_name, :string, limit: 255
  end
end
