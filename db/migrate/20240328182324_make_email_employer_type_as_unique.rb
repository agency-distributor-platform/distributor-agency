require_relative "./migration_utils.rb"

class MakeEmailEmployerTypeAsUnique < ActiveRecord::Migration[7.0]

  include MigrationUtils
  TABLE_NAME = :users
  OLD_INDEX_NAME = :users_unique_email
  NEW_INDEX_NAME = :users_unique_employer_type_email

  def up
    remove_index_with_verification(TABLE_NAME, OLD_INDEX_NAME)
    add_index_to_columns(TABLE_NAME, [:employer_type, :email], {name: NEW_INDEX_NAME})
  end

  def down
    remove_index_with_verification(TABLE_NAME, NEW_INDEX_NAME)
    add_index_to_columns(TABLE_NAME, [:email], {name: OLD_INDEX_NAME})
  end
end
