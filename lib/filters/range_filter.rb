require_relative "./base_filter.rb"

module Filters
  class RangeFilter < BaseFilter

    include Utils::Pagination
    def initialize(model, column, values=[])
      super(model, values)
      @column = column
    end

    def apply_filter
      start_value = values.first
      end_value = values.second
      model.where("#{column} >= #{start_value} AND #{column} <= #{end_value}")
    end

  end
end
