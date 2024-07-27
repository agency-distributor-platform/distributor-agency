class AddTitleToBuyer < ActiveRecord::Migration[7.0]
  def change
    add_column :buyers, :title, :string
  end
end
