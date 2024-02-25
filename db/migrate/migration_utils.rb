module MigrationUtils

  private

  def alter_column_datatype_with_verification(table_name, column_name, datatype)
    change_column table_name, column_name, datatype if table_exists?(table_name) && column_exists?(table_name, column_name)
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end

  def add_with_verification_column(table_name, column_name, datatype)
    if table_exists? table_name
      add_column table_name, column_name, datatype unless column_exists? table_name, column_name
    end
  end

  def remove_with_verification_column(table_name, column_name)
    if table_exists? table_name
      remove_column table_name, column_name if column_exists? table_name, column_name
    end
  end

  def add_index_to_columns(source_table, columns, properties)
    remove_index_with_verification(source_table, properties[:name])
    add_index source_table, columns, **properties
  end

  def remove_index_with_verification(source_table, index_name)
    remove_index source_table, name: index_name if index_name_exists?(source_table, index_name)
  end

  def add_foreign_key_column(source_table, reference_table, column_name)
    add_foreign_key(source_table, reference_table, column: column_name) if table_exists?(source_table) && column_exists?(source_table, column_name) && !foreign_key_exists?(source_table, column: column_name)
  end

  def remove_foreign_key_column(source_table, reference_table=nil, column_name=nil)
    if table_exists?(source_table)
      if column_name.present? && column_exists?(source_table, column_name)
        remove_foreign_key(source_table, column: column_name)
      elsif reference_table.present? && table_exists?(reference_table)
        remove_foreign_key(source_table, reference_table)
      end
    end
  end

  def add_enum_constraints(table_name, column_name, allowed_values)
    constraint_name = "valid_#{column_name}_constraint"
    quoted_table_name = ActiveRecord::Base.connection.quote_table_name(table_name)
    quoted_column_name = ActiveRecord::Base.connection.quote_column_name(column_name)
    allowed_values_list = allowed_values.map { |value| ActiveRecord::Base.connection.quote(value) }.join(", ")

    execute <<-SQL
      ALTER TABLE #{quoted_table_name}
      ADD CONSTRAINT #{constraint_name}
      CHECK (#{quoted_column_name} IN (#{allowed_values_list}))
    SQL
  end

  def delete_table(table)
    drop_table table if table_exists? table
  end

end
