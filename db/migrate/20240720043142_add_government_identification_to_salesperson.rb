require_relative "./migration_utils.rb"

class AddGovernmentIdentificationToSalesperson < ActiveRecord::Migration[7.0]

  include MigrationUtils
  TABLE_NAME = :salespersons
  COLUMNS = {
    government_document: :string,
    government_document_identification: :string,
  }

  def up
    COLUMNS.keys.each { |key|
      add_with_verification_column(TABLE_NAME, key, COLUMNS[key])
    }
  end

  def down
    COLUMNS.keys.each { |key|
      remove_with_verification_column(TABLE_NAME, key)
    }
  end
end
