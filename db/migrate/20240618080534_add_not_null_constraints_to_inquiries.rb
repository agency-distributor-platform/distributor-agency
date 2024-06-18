class AddNotNullConstraintsToInquiries < ActiveRecord::Migration[7.0]
  def up
    change_column_null :inquiries, :name, false
    change_column_null :inquiries, :phone, false
  end

  def down
    # Remove NOT NULL constraint in case of rollback
    change_column_null :inquiries, :name, true
    change_column_null :inquiries, :phone, true
  end
end
