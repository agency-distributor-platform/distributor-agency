class UserController < AuthenticationController

  def current_user_details
    user_details = user.as_json
    user_details["employer_id"] = convert_id_to_uuid(user_details["employer_id"])
    user_details.delete("password")
    render json: user_details, status: 200
  end

  def user_details
    user_id = convert_uuid_to_id(params[:user_id])
    user_details = User.find_by(id: user_id).as_json
    user_details["employer_id"] = convert_id_to_uuid(user_details["employer_id"])
    user_details.delete("password")
    render json: user_details, status: 200
  end

end
