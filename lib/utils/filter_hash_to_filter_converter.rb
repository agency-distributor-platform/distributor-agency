require_relative "./../filters/all_filters.rb"

module Utils
  class FilterHashToFilterConverter

    include Filters

    def self.convert(filter_hash, model, association_mapping_for_associated_range_columns)
      filters = []
      filter_hash.each { |key, values|
        if model.columns_hash.keys.include?(key.to_s)
          column_datatype = get_column_type(model, key)
          if column_datatype == "bigint" && key.to_s != "kms_driven"
            filters.push(IdFilter.new(model, key, values))
          elsif column_datatype == "varchar"
            filters.push(ValueFilter.new(model, key, values))
          elsif column_datatype == "enum"
            filters.push(ValueFilter.new(model, key, values))
          else
            filters.push(RangeFilter.new(model, key, values))
          end
        else
          if association_mapping_for_associated_range_columns[key].present?
            filter_values = {
              column: key,
              range: values
            }
            filters.push(Filters::JoinRangeFilter.new(model, association_mapping_for_associated_range_columns[key], filter_values))
          else
            filters.push(Filters::JoinIdFilter.new(model, key, values))
          end
        end
      }
      filters
    end

    private

    def self.get_column_type(model, column_name)
      column = model.columns.find { |c| c.name == column_name.to_s }
      return 'Column not found' unless column
      enum_type_regex = /^enum\(.+\)$/

      case column.sql_type
      when 'bigint'
        'bigint'
      when 'float'
        'float'
      when 'integer'
        'integer'
      when 'varchar'
        'varchar'
      when enum_type_regex
        'enum'
      else
        column.sql_type
      end
    end
  end
end
