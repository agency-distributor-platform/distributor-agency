require_relative "./migration_utils.rb"

class CreateReferrals < ActiveRecord::Migration[7.0]

  include MigrationUtils

  def up
    unless table_exists? :referrals
      create_table :referrals do |t|
        t.bigint :salesperson_id
        t.string :buyer_government_document
        t.string :buyer_government_document_identification
        t.timestamps
      end
    end
  end

  def down
    delete_table(:referrals)
  end
end
