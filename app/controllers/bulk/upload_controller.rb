module Bulk 
  class UploadController < ApplicationController
    def vehicle_details_template
      file = Tempfile.new("vehicle_details_upload")
      records = []
      records << Constants::VEHICLE_DETAILS_UPLOAD_HEADERS
      Utils::FileParserFactory.get_parser('xlsx').write(file, records)
      file.rewind
      yield file if block_given?
      #send_file(file)
      send_file(file.path, type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', disposition: 'attachment', filename: 'vehicle_details_template.xlsx')
    ensure
      file.close
      file.unlink
    end
  end 
end 