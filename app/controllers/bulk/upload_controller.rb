module Bulk 
  class UploadController < ApplicationController
    def vehicle_details_template
      file = 'vehicle_details_template.xlsx'
      records = [Constants::VEHICLE_DETAILS_UPLOAD_HEADERS]
      p records
      Utils::FileParserFactory.get_parser('xlsx').write(file, records)
      send_file(file, type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', disposition: 'attachment')
    end
  end 
end 