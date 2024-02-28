class AuthenticationController < ApplicationController
  before_action :check_token_access, except: [:login]

  #TO-DO: Catch all errors and send error api response
  def login
    email = params[:email]
    password = params[:email]
    if User.where(email: , password: ).present?
      render json: {
        token: hard_coded_token
      }, status: 200
    else
      render json: {
        error: "Not Authenticated"
      }, status: 401
    end
  end

  def register
    begin
      user_type_model = user_type_details[:type].constantize
      user_type_id = user_type_details[:id]
      user = nil
      ApplicationRecord.transaction do
        if user_type_id.blank?
          user_type_record = user_type_model.create!({
            name: user_type_details[:name],
            email: user_type_details[:email],
            phone: user_type_details[:phone]
          })
          user_type_record.update({uuid: user_type_model.generate_uuid}) rescue nil
          user_type_id = user_type_record.id
          user_type_record.create_super_user
        end
        user = User.create!(user_params.merge!({employer_type: user_type_details[:type], employer_id: user_type_id}))
      end
      render json: {
        user_type_details: {
          id: user_type_id,
          user_type: user_type_details[:type]
        }, user_details: user.as_json
      }, status: 200
    rescue => e
      render json: {
        error: e.message
      }, status: 500
    end


  end

  private

  def check_token_access
    token = request.headers["Authorization"].split("Bearer ")[1] rescue nil
    raise "User not authenticated" if token != hard_coded_token
  end

  def hard_coded_token
    "sample_token"
  end

  def user_params
    params.require(:user_details).permit(:email, :name, :phone, :password)
  end

  def user_type_details
    params.require(:user_type_details)
  end

end
