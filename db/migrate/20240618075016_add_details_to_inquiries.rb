require_relative "./migration_utils.rb"
class AddDetailsToInquiries < ActiveRecord::Migration[7.0]
  include MigrationUtils
  TABLE_NAME = :inquiries
  def change
    add_with_verification_column(TABLE_NAME, :name, :string)
    add_with_verification_column(TABLE_NAME, :email, :string)
    add_with_verification_column(TABLE_NAME, :phone, :bigint)
  end
end
