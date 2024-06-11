module Bulk 
  class UploadController < ApplicationController
    def vehicle_details_template
      file = UploadService::BulkUpload.new.download_template
      send_file(file, type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', disposition: 'attachment')
    end

    def vehicle_details
      response, status = UploadService::BulkUpload.new.upload_vehicle_details(params)
      render json: response.to_json, status: status
    end 
  end 
end 