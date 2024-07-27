require_relative "./migration_utils.rb"
class AddPhoneToBuyer < ActiveRecord::Migration[7.0]
  include MigrationUtils
  TABLE_NAME = :buyers
  def up
    add_with_verification_column(TABLE_NAME, :phone, :string)
  end

  def down
    remove_with_verification_column(TABLE_NAME, :phone, :string)
  end
end
