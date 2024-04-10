class UserController < AuthenticationController

  def current_user_details
    derived_user_details = derive_user_details(user.as_json)
    render json: derived_user_details, status: 200
  end

  def user_details
    user_id = convert_uuid_to_id(params[:user_id])
    derived_user_details = derive_user_details(User.find_by(id: user_id).as_json)
    render json: derived_user_details, status: 200
  end

  private

  def derive_user_details(user_details)
    user_details["id"] = convert_id_to_uuid(user_details["id"])
    user_details["employer_id"] = convert_id_to_uuid(user_details["employer_id"])
    user_details.delete("password")
    user_details
  end

end
