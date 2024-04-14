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

end
