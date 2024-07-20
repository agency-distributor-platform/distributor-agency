module BusinessLogic
  class BuyerObj

    attr_accessor :record

    def initialize(record)
      @record = record[:id].present? ? Buyer.find_by(id: record[:id]) : Buyer.new(record)
    end

    def create_or_update(buyer_details)
      record.update(buyer_details)
    end

    def record_id
      record.id
    end

    def as_json
      record.as_json_with_converted_id
    end

    def referred_by
      aadhar_no = record.addhar
      if aadhar_no.present?
        Referral.find_by({buyer_government_document: "Aadhar", buyer_government_document_identification: aadhar_no}).salesperson
      end

      pan = record.pan
      if pan.present?
        Referral.find_by({buyer_government_document: "PAN", buyer_government_document_identification: pan_no}).salesperson
      end

      nil
    end

  end
end
