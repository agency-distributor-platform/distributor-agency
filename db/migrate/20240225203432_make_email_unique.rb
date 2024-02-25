require_relative "./migration_utils.rb"

class MakeEmailUnique < ActiveRecord::Migration[7.0]
  include MigrationUtils

  TABLE_NAMES = [:users, :agencies, :distributors]

  def up
    TABLE_NAMES.each { |table|
      add_index_to_columns(table, :email, {name: email_index_name(table), unique: true})
    }
  end

  def down
    TABLE_NAMES.each { |table|
      remove_index_with_verification(table, {name: email_index_name(table)})
    }
  end

  private

  def email_index_name(table_name)
    "#{table_name}_unique_email"
  end
end
