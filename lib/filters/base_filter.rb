module Filters
  class BaseFilter

    attr_reader :model, :values
    attr_accessor :association, :column

    def initialize(model, values=[])
      @model = model
      @values = values
    end

    def apply_filter
      filter_hash = {}
      filter_hash[related_data_filter_method] = values
      model.where(filter_hash)
    end

    private

    def related_data_filter_method
      column || association
    end

  end
end
