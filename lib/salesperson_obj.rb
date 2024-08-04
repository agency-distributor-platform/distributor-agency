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


    private

    def derive_model(item_type)
      "#{item_type.capitalize}".constantize
    end

  end
end
