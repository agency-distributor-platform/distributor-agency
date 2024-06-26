require_relative "./base_filter.rb"
require_relative "./../utils/pagination.rb"

module Filters
  class IdFilter < BaseFilter

    include Utils::Pagination
    def initialize(model, column, values=[])
      super(model, values)
      @column = column.to_sym
    end

  end
end
