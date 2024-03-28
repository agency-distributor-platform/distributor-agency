require "#{Rails.root}/lib/authentication/jwt_token.rb"
require "#{Rails.root}/lib/utils/address_utils.rb"

class AuthenticationController < ApplicationController
  before_action :check_token_access, except: [:login, :register]

  include Authentication
  include Utils

  #TO-DO: Catch all errors and send error api response
  def login
    email = params[:email]
    password = params[:password]
    user = User.find_by(email: , password: )
    if user.present?
      render json: {
        token: JwtTokenUtils.encode({
          email: user.email
        })
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
          raise "False Pincode Format" if user_type_details[:pincode].present? && is_false_pincode?(user_type_details[:pincode])
          raise "False state value" if user_type_details[:state].present? && is_false_state_or_ut?(user_type_details[:state])
          user_type_record = user_type_model.create!({
            name: user_type_details[:name],
            email: user_type_details[:email],
            phone: user_type_details[:phone],
            address: user_type_details[:address],
            city: user_type_details[:city],
            state: user_type_details[:state],
            pincode: user_type_details[:pincode]
          })
          user_type_id = user_type_record.id
          user_type_record.create_super_user if user_type_details[:email] != user_params[:email]
        end
        user = User.create!(user_params.merge!({employer_type: user_type_details[:type], employer_id: user_type_id}))
      end
      user_details = user.as_json
      user_details[:id] = convert_id_to_uuid(user.id)
      user_type_id = convert_id_to_uuid(user_type_id)
      user_details[:employer_id] = user_type_id
      render json: {
        user_type_details: {
          id: user_type_id,
          user_type: user_type_details[:type]
        }, user_details:
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
    raise "User not authenticated" if token.blank?
    begin
      $user = User.find_by(email: JwtTokenUtils.decode(token).first["email"])
    rescue
      raise "User not authenticated"
    end

    raise "User not found" if $user.blank?
  end

  def user_params
    params.require(:user_details).permit(:email, :name, :phone, :password)
  end

  def user_type_details
    params.require(:user_type_details)
  end

  def is_false_pincode?(pincode)
    AddressUtils.is_false_pincode?(pincode)
  end

  def is_false_state_or_ut?(state_or_ut)
    AddressUtils.is_false_state_or_ut?(state_or_ut)
  end

end
