require_relative "./migration_utils.rb"

class AddCompositeUniqueIndexesForSalespersonAgenecyLinks < ActiveRecord::Migration[7.0]

  include MigrationUtils

  def up
    add_index_to_columns :salesperson_agency_linkings, [:salesperson_id, :agency_id], unique: true, name: "index_salesperson_agency_linkings"
  end

  def down
    remove_index_with_verification :salesperson_agency_linkings, "index_salesperson_agency_linkings"
  end
end
