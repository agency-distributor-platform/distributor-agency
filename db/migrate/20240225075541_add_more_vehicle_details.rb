require_relative "./migration_utils.rb"

class AddMoreVehicleDetails < ActiveRecord::Migration[7.0]
  include MigrationUtils
  TABLE_NAME = :vehicles

  def up
    add_with_verification_column(TABLE_NAME, :loan_or_agreement_number, :string)
    add_with_verification_column(TABLE_NAME, :stock_entry_date, :string)
    add_with_verification_column(TABLE_NAME, :comments, :text)
    add_with_verification_column(TABLE_NAME, :location, :string)
  end

  def down
    remove_with_verification_column(TABLE_NAME, :loan_or_agreement_number)
    remove_with_verification_column(TABLE_NAME, :stock_entry_date)
    remove_with_verification_column(TABLE_NAME, :comments)
    remove_with_verification_column(TABLE_NAME, :location, :string)
  end
end
