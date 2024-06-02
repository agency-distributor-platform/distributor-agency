require "#{Rails.root}/lib/adapters/google_drive.rb"
require "zip"

module ItemService
  class VehicleObj < ItemObj

    attr_accessor :photo_file_path, :photo_file_name

    include Adapters

    def create_or_update(params, agency_id=nil)
      ApplicationRecord.transaction {
        if !(record.persisted?)
          photos = params.delete(:photos)
          update(params)
          raise "No Agency found" if agency_id.blank?
          item_status_obj = ItemStatusObj.create_obj(self, agency_id)
          item_status_obj.set_added_status
          p record.agency
          create_folder_structure_in_google_drive
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
      google_drive_adapter = GoogleDrive.new
      google_drive_folder = record.google_drive_folder_id
      photos_folder_id = find_folder_id(google_drive_adapter, "photos", google_drive_folder)
      download_photos(google_drive_adapter, photos_folder_id)
    end

    private

    #TO-DO: Cleanup single use variables into directly using them
    def create_folder_structure_in_google_drive
      vehicle_model = record.vehicle_model
      company_name = vehicle_model.company_name
      model_name = vehicle_model.model
      agency_record = record.agency
      agency_folder_name = "Agency_#{agency_record.name}_#{agency_record.id}"
      google_drive_adapter = GoogleDrive.new
      dealdrive_folder_id = google_drive_adapter.get_dealdrive_folder_info
      agency_folder_id = find_folder_id(google_drive_adapter, agency_folder_name, dealdrive_folder_id)
      company_name_folder_id = find_or_create_if_no_folder(google_drive_adapter, company_name, agency_folder_id)
      model_folder_id = find_or_create_if_no_folder(google_drive_adapter, model_name, company_name_folder_id)
      create_vehicle_specific_folders(google_drive_adapter, model_folder_id)
    end

    def find_or_create_if_no_folder(google_drive_adapter, folder, parent_folder_id)
      existing_folder_id = find_folder_id(google_drive_adapter, folder, parent_folder_id)
      return create_folder(google_drive_adapter, folder, parent_folder_id)[:id] if existing_folder_id.blank?
      existing_folder_id
    end

    def create_vehicle_specific_folders(google_drive_adapter, model_folder_id)
      vehicle_root_folder = google_drive_adapter.create_folder("#{record.registration_id}_#{record.id}", model_folder_id)
      record.google_drive_folder_id = vehicle_root_folder[:id]
      record.save!

      create_folder(google_drive_adapter, "photos", vehicle_root_folder[:id])
      create_folder(google_drive_adapter, "documents", vehicle_root_folder[:id])
      create_folder(google_drive_adapter, "others", vehicle_root_folder[:id])
    end

    def find_folder_id(google_drive_adapter, folder_name, parent_folder_id)
      google_drive_adapter.find_folder(folder_name, parent_folder_id)[:id]
    end

    def create_folder(google_drive_adapter, folder, parent_folder_id)
      google_drive_adapter.create_folder(folder, parent_folder_id)
    end

    def upload_photos(photos)
      google_drive_adapter = GoogleDrive.new
      vehicle_root_folder_id = record.google_drive_folder_id
      photo_folder_id = find_folder_id(google_drive_adapter, "photos", vehicle_root_folder_id)
      photos.each { |photo|
        google_drive_adapter.upload_file(photo, photo_folder_id)
      }
    end

    def download_photos(google_drive_adapter, photos_folder_id)
      @photo_file_path = create_zip(google_drive_adapter.download_files(photos_folder_id))
    end

    def create_zip(files)
      @photo_file_name = "google_drive_files_#{Time.now.to_i}.zip"
      zip_path = Rails.root.join('tmp', photo_file_name)
      Zip::File.open(zip_path, Zip::File::CREATE) do |zipfile|
        files.each do |file|
          zipfile.get_output_stream(file[:name]) { |f| f.write(file[:content]) }
        end
      end
      zip_path
    end

  end
end
