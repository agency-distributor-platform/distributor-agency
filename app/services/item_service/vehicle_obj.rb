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
          params.delete(:deleted_photos)
          update(params)
          raise "No Agency found" if agency_id.blank?
          item_status_obj = ItemStatusObj.create_obj(self, agency_id)
          item_status_obj.set_added_status
          create_folder_structure_in_s3
          upload_photos(photos) if photos.present?
        else
          photos = params.delete(:photos)
          deleted_photos = params.delete(:deleted_photos)
          old_vehicle_root_path = vehicle_root_s3_path
          copy_objects_to_new_folder(record, params) if (params[:registration_id] != record.registration_id) || (params[:vehicle_model_id].to_i != record.vehicle_model_id.to_i)
          update(params)
          new_vehicle_root_s3_path = vehicle_root_s3_path
          upload_photos(photos) if photos.present?
          delete_photos({old_vehicle_root_path:, new_vehicle_root_s3_path:, photos: deleted_photos}) if deleted_photos.present?
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
    # TO-DO : refactor to use single method to get any type of photos
    def get_add_on_photos(add_on_id)
      photos_path = "#{vehicle_other_files_path}/add_ons/#{add_on_id}"
      files = s3_adapter.list_files(photos_path)
      { files: files.map { |file| {filename: file, publi_url: s3_adapter.public_url(file)} } }
    end 

    # TO-DO : refactor to use single method tp upload any type of photos
    def upload_add_on_photos(photos, add_on_id)
      photos.each_with_index { |photo, index|
        file_path = photo.tempfile.path
        file_name = photo.original_filename
        s3_adapter.upload_file(file_path, "#{vehicle_other_files_path}/add_ons/#{add_on_id}/#{file_name}")
      }
    end

    def upload_document_file(local_file_path, filename)
      s3_adapter.upload_file(local_file_path, "#{vehicle_documents_path}/#{filename}")
    end

    def download_document_file(filename, local_path)
      s3_file_path = "#{vehicle_documents_path}/#{filename}"
      s3_adapter.download(s3_file_path, local_path)
    end

    def delete_add_on_photos(photos) 
      delete_photos({old_vehicle_root_path: vehicle_root_s3_path, new_vehicle_root_s3_path: vehicle_root_s3_path, photos: })
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

    def derive_new_vehicle_root_s3_path(params)
      new_registration_id = params[:registration_id]
      vehicle_model = VehicleModel.find_by(id: params[:vehicle_model_id])
      "#{agency_s3_root_path}/#{vehicle_model.company_name}/#{vehicle_model.model}/#{new_registration_id}_#{record.id}"
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
      photos.each_with_index { |photo, index|
        file_path = photo.tempfile.path
        file_name = photo.original_filename
        s3_adapter.upload_file(file_path, "#{vehicle_photos_path}/#{file_name}")
      }
    end
 
    def copy_objects_to_new_folder(record, params)
      s3_adapter.copy_object_to_new_folder(vehicle_root_s3_path, derive_new_vehicle_root_s3_path(params))
    end

    def delete_photos(options)
      photos = options[:photos]
      old_vehicle_root_path = options[:old_vehicle_root_path]
      new_vehicle_root_s3_path = options[:new_vehicle_root_s3_path]
      photos.each { |photo|
        s3_adapter.delete_file(photo.sub(old_vehicle_root_path, new_vehicle_root_s3_path))
      }
    end

  end
end
