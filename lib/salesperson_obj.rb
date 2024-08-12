module BusinessLogic
  class SalespersonObj

    attr_accessor :record
    def initialize(record)
      @record = record[:id].present? ? Salesperson.find_by(id: record[:id]) : Salesperson.new(record)
    end

    def update(params)
      record.update(params)
    end

    def record_id
      record.id
    end

    def is_verified?
      record.is_verified?
    end

    def create_referral(government_document_details)
      Referral.create!({
        salesperson_id: record_id,
        buyer_government_document: government_document_details[:buyer_government_document],
        buyer_government_document_identification: government_document_details[:buyer_government_id],
      })
    end

    def linked_agencies
      record.linked_agencies
    end

    def verified_linked_agencies
      record.salesperson_agency_linkings.where(is_verified: true).map(&:agency)
    end

    def raise_linking_request(agency_id)
      SalespersonAgencyLinking.create!({
        salesperson_id: record_id,
        agency_id:
      }) if record.linked_agencies.where(id: agency_id).blank?
    end

    def get_earnings
      revenue = 0
      record.item_statuses.each { |item|
        item_status_obj = ItemService::ItemStatusObj.new(item)
        revenue = revenue + item_status_obj.salesperson_share
      }

      {
        revenue_on_paper: revenue,
        total_revenue: revenue
      }
    end

    def linking_requests(linking_request_filter)
      linking_request_list = []
      record.salesperson_agency_linkings.where(linking_request_filter).as_json.each { |linking_request|
        linking_request[:agency_id] = convert_id_to_uuid(linking_request["agency_id"])
        linking_request_list.push(linking_request)
      }
      linking_request_list
    end

    private

    def convert_id_to_uuid(id)
      Base64.encode64(id.to_s).strip
    end

    def derive_model(item_type)
      "#{item_type.capitalize}".constantize
    end

  end
end
