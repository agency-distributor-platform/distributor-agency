require_relative "./migration_utils.rb"

class AddIsVerifiedColumnToSalespersonAgencyLinkings < ActiveRecord::Migration[7.0]

  include MigrationUtils
  TABLE_NAME = :salesperson_agency_linkings
  COLUMN_NAME = :is_verified
  def up
    add_with_verification_column(TABLE_NAME, COLUMN_NAME, :boolean)
    #column should have default value of false
    change_column_default(TABLE_NAME, COLUMN_NAME, from: nil, to: false)
  end

  def down
    remove_with_verification_column(TABLE_NAME, COLUMN_NAME)
  end
end
