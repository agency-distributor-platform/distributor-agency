# require "#{Rails.root}/lib/adapters/google_drive.rb"
require "#{Rails.root}/lib/adapters/s3_file.rb"

module ItemService
  class VehicleObj < ItemObj

    attr_accessor :s3_adapter

    include Adapters

    def initialize(record)
      super
      @s3_adapter = S3File.new
    end

    def create_or_update(params, agency_id=nil)
      ApplicationRecord.transaction {
        if !(record.persisted?)
          photos = params.delete(:photos)
          update(params)
          raise "No Agency found" if agency_id.blank?
          item_status_obj = ItemStatusObj.create_obj(self, agency_id)
          item_status_obj.set_added_status
          create_folder_structure_in_s3
          upload_photos(photos)
        else
          update(params)
        end
      }
    end

    def model_name
      "Vehicle"
    end

    def model
      Vehicle.includes(:item_status)
    end

    def get_photos
      files = s3_adapter.list_files(vehicle_photos_path)
      { files: files.map { |file| {filename: file, publi_url: s3_adapter.public_url(file)} } }
    end

    private

    def create_folder_structure_in_s3
      s3_adapter.create_folder_if_not_created(agency_s3_root_path)
      s3_adapter.create_folder_if_not_created(vehicle_root_s3_path)
      s3_adapter.create_folder_if_not_created(vehicle_photos_path)
      s3_adapter.create_folder_if_not_created(vehicle_documents_path)
      s3_adapter.create_folder_if_not_created(vehicle_other_files_path)
    end

    def agency_s3_root_path
      "Agency_#{agency_record.name}_#{agency_record.id}"
    end

    def agency_record
      record.agency
    end

    def vehicle_model_record
      record.vehicle_model
    end

    def vehicle_root_s3_path
      "#{agency_s3_root_path}/#{vehicle_model_record.company_name}/#{vehicle_model_record.model}/#{record.registration_id}_#{record.id}"
    end

    def vehicle_photos_path
      "#{vehicle_root_s3_path}/photos"
    end

    def vehicle_documents_path
      "#{vehicle_root_s3_path}/documents"
    end

    def vehicle_other_files_path
      "#{vehicle_root_s3_path}/other"
    end

    def upload_photos(photos)
      photos.each { |photo|
        file_path = photo.tempfile.path
        file_name = photo.original_filename
        s3_adapter.upload_file(file_path, "#{vehicle_photos_path}/#{file_name}")
      }
    end

  end
end
