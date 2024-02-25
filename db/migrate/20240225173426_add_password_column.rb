require_relative "./migration_utils.rb"

class AddPasswordColumn < ActiveRecord::Migration[7.0]
  include MigrationUtils
  TABLE_NAME = :users
  def up
    add_index_to_columns(TABLE_NAME, :email, {name: index_name(:email)})
    add_with_verification_column(TABLE_NAME, :password, :string)
  end

  def down
    remove_index_with_verification(TABLE_NAME, index_name(:email))
    remove_with_verification_column(TABLE_NAME, :password)
  end

  private

  def index_name(column)
    "#{TABLE_NAME}_unique_#{column}"
  end

end
