require "set"
require_relative "./base_filter.rb"
require_relative "./range_filter.rb"

module Filters
  class JoinRangeFilter < BaseFilter

    attr_reader :associated_model

    def initialize(model, association, values={})
      super(model, values)
      @association = association
    end

    def apply_filter
      column = values[:column]
      range = values[:range]

      associated_records = Filters::RangeFilter.new(associated_model, column, range).apply_filter
      inverse_association = get_inverse_association rescue nil
      records = []
      associated_records.each { |associated_record|
        if inverse_association.present?
          records.push(associated_record.send("#{inverse_association}"))
        else
          records.push(associated_record.item_type.constantize.find_by(id: associated_record.item_id))
        end
      }
      records.uniq
    end

    private

    def associated_model
      @associated_model = @associated_model || get_associated_model
    end

    def get_associated_model
      model.reflect_on_association(association.to_sym).klass
    end

    def get_inverse_association
      associated_model.reflect_on_all_associations.each do |assoc|
        if assoc.klass == model
          return assoc
        end
      end
    end

  end
end
