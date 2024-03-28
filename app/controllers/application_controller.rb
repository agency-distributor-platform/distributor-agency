require 'digest'

class ApplicationController < ActionController::API

  private

  def convert_id_to_uuid(id)
    Base64.encode64(id.to_s).strip
  end

  def convert_uuid_to_id(uuid)
    Base64.decode64(uuid.to_s)
  end
end
