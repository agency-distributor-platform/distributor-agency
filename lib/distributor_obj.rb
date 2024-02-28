module BusinessLogic
  class DistributorObj

    attr_accessor :record

    def initialize(record)
      @record = record[:id].present? ? Distributor.find_by(id: record[:id]) : Distributor.new(record)
    end

    def link_to_agency(agency_obj)
      if record_present?
        return if agency_obj.distributors.pluck(:id).include?(record_id)
        record.distributor = agency_obj.record
        record.save!
      else
        raise "Wrong distributor record"
      end
    end

    def record_present?
      record.id.present?
    end

    def record_id
      record.id
    end

  end
end
