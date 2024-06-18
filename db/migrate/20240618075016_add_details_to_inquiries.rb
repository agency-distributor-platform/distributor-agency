class AddDetailsToInquiries < ActiveRecord::Migration[7.0]
  def change
    add_column :inquiries, :name, :string
    add_column :inquiries, :email, :string
    add_column :inquiries, :phone, :bigint
  end
end
