require_relative "./base_filter.rb"

module Filters
  class ValueFilter < BaseFilter #maybe needed for substring search kind of things later

    include Utils::Pagination
    def initialize(model, column, values=[])
      super(model, values)
      @column = column
    end

  end
end
