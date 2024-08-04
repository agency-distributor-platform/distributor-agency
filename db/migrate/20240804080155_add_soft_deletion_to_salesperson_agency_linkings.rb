require_relative "./migration_utils.rb"

class AddSoftDeletionToSalespersonAgencyLinkings < ActiveRecord::Migration[7.0]

  include MigrationUtils
  def up
    add_with_verification_column :salesperson_agency_linkings, :rejected, :boolean
    change_column_default :salesperson_agency_linkings, :rejected, false
  end

  def down
    remove_with_verification_column :salesperson_agency_linkings, :rejected
  end
end
