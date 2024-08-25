module BusinessLogic
  class BuyerObj

    attr_accessor :record

    def initialize(record)
      @record = record[:id].present? ? Buyer.find_by(id: record[:id]) : Buyer.new(record)
    end

    def create_or_update(buyer_details, vehicle_id=nil)
      pancard_photo = buyer_details.delete(:pancard_photo)
      adharcard_back_photo = buyer_details.delete(:adharcard_back_photo)
      adharcard_front_photo = buyer_details.delete(:adharcard_front_photo)
      signature_photo = buyer_details.delete(:signature_photo)
      record.update(buyer_details)
      if vehicle_id.present?
        set_vehcile_obj(vehicle_id)
        upload_pancard_photo(pancard_photo) if pancard_photo.present?
        upload_signature_photo(signature_photo) if signature_photo.present?
        upload_adharcard_photos(adharcard_back_photo, adharcard_front_photo) if adharcard_back_photo.present? && adharcard_front_photo.present?
      end
    end

    def get_buyer_photos(vehicle_id)
      set_vehcile_obj(vehicle_id)
      photos_hash = @vehicle_obj.get_buyers_photo_hash
      return photos_hash
    end

    def record_id
      record.id
    end

    def as_json
      record.as_json_with_converted_id
    end

    def get_photo(photo_name)
      @vehicle_obj.get_photo(photo_name)
    end

    def upload_pancard_photo(photo)
      upload_photo(photo, 'pancard')
    end

    def upload_signature_photo(photo)
      upload_photo(photo, 'signature')
    end

    def upload_adharcard_photos(back_photo, front_photo)
      upload_photo(back_photo, 'adhar_back')
      upload_photo(front_photo, 'adhar_front')
    end

    def upload_photo(photo, name_prefix)
      photo_path = photo.tempfile.path
      ext = get_extension(photo)
      photo_name = "#{name_prefix}.#{ext}"
      @vehicle_obj.upload_buyer_photo(photo_path, photo_name)
    end

    def get_extension(photo)
      MIME::Types[photo.content_type].first.preferred_extension
    end

    def referred_by
      aadhar_no = record.addhar
      if aadhar_no.present?
        referal = Referral.find_by({buyer_government_document: "Aadhar", buyer_government_document_identification: aadhar_no})
        return referal.salesperson if referal.present?
      end

      pan = record.pan
      if pan.present?
        referal = Referral.find_by({buyer_government_document: "PAN", buyer_government_document_identification: pan})
        return referal.salesperson if referal.present?
      end

      nil
    end

    def set_vehcile_obj(vehicle_id)
      @vehicle_obj = ItemService::VehicleObj.new({id: vehicle_id})
    end

  end
end
