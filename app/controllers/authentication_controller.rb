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
    employer_type = params[:login_type]
    user = User.find_by(email: , password: , employer_type: )
    derived_user_details = derive_user_details(user)
    if user.present?
      token = JwtTokenUtils.encode({
        timestamp: DateTime.now.to_s,
        email: user.email,
        # user_type: user.employer_type,
        user_id: user.id
      })
      Session.create!(session_id: token)#, user_id: user.id)
      render json: {
        token:,
        user_details: derived_user_details
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
    user_details = JwtTokenUtils.decode(token).first
    begin
      $user = User.find_by(id: user_details["user_id"])#, employer_type: user_details["user_type"])
      $session = Session.find_by(session_id: token)
      #TO-DO: Make the time expiry constant
      if DateTime.now.to_i - $session.updated_at.to_i > 1800000
        $session.delete
        $session = nil
      else
        $session.update!(updated_at: DateTime.now)
      end
    rescue
      raise "User not authenticated"
    end

    raise "User not found" if $user.blank?
    raise "Session expired" if $session.blank?
  end

  def user
    $user if $user.present?
  end

  def session_user_service
    UserService.new(user)
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
