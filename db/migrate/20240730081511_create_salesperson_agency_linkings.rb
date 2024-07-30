require_relative './migration_utils.rb'

class CreateSalespersonAgencyLinkings < ActiveRecord::Migration[7.0]

  include MigrationUtils
  TABLE_NAME = :salesperson_agency_linkings
  def up
    unless table_exists?(TABLE_NAME)
      create_table TABLE_NAME do |t|
        t.references :salesperson, null: false, foreign_key: { to_table: :salespersons }
        t.references :agency, null: false, foreign_key: { to_table: :agencies }

        t.timestamps
      end
    end
  end

  def down
    delete_table TABLE_NAME
  end
end
