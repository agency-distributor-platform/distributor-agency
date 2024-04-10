class UserController < AuthenticationController

  def current_user_details
    derived_user_details = derive_user_details(user)
    render json: derived_user_details, status: 200
  end

  def user_details
    user_id = convert_uuid_to_id(params[:user_id])
    derived_user_details = derive_user_details(User.find_by(id: user_id))
    render json: derived_user_details, status: 200
  end

  private

  def derive_user_details(user_record)
    user_details = user_record.as_json
    user_details["id"] = convert_id_to_uuid(user_details["id"])
    user_details["employer_id"] = convert_id_to_uuid(user_details["employer_id"])
    user_details.delete("password")

    user_details["user_type_details"] = user_record.employer.as_json
    user_details["user_type_details"]["id"] = convert_id_to_uuid(user_details["user_type_details"]["id"])
    user_details["user_type_details"]["agency_id"] = convert_id_to_uuid(user_details["user_type_details"]["agency_id"]) if user_details["user_type_details"]["agency_id"].present?

    user_details
  end

end
