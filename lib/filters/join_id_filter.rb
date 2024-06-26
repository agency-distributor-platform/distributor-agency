require_relative "./base_filter.rb"

module Filters
  class JoinIdFilter < BaseFilter

    def initialize(model, association, values=[])
      super(model, values)
      @association = association
    end

    def apply_filter
      model.includes(association.to_sym).where("#{association}": {"id": values})
    end

  end
end
