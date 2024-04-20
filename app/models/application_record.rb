class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  def as_json_with_converted_id
    json_details = as_json
    json_details["id"] = convert_id_to_uuid(json_details["id"])
    json_details
  end

  private

  def convert_id_to_uuid(id)
    Base64.encode64(id.to_s).strip
  end
end
