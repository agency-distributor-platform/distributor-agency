require 'digest'

class ApplicationController < ActionController::API

  rescue_from JWT::VerificationError, with: :invalid_signature
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
  rescue_from ActiveRecord::RecordNotUnique, with: :record_not_unique
  rescue_from ActionController::RoutingError, with: :routing_error
  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  rescue_from StandardError, with: :internal_server_error

  private

  def convert_id_to_uuid(id)
    Base64.encode64(id.to_s).strip
  end

  def convert_uuid_to_id(uuid)
    Base64.decode64(uuid.to_s).to_i
  end

  def invalid_signature(exception)
    render json: { error: "Invalid token signature", message: exception.message }, status: :unauthorized
  end

  def invalid_token(exception)
    render json: { error: "Invalid token", message: exception.message }, status: :unauthorized
  end

  def expired_token(exception)
    render json: { error: "Expired token", message: exception.message }, status: :unauthorized
  end

  def record_not_found(exception)
    render json: { error: "Record not found", message: exception.message }, status: :not_found
  end

  def unprocessable_entity(exception)
    render json: { error: "Unprocessable entity", message: exception.message }, status: :unprocessable_entity
  end

  def record_not_unique(exception)
    render json: { error: "Record not unique", message: exception.message }, status: :conflict
  end

  def routing_error(exception)
    render json: { error: "Route not found", message: exception.message }, status: :not_found
  end

  def parameter_missing(exception)
    render json: { error: "Parameter missing", message: exception.message }, status: :bad_request
  end

  def internal_server_error(exception)
    render json: { error: "Internal server error", message: exception.message }, status: :internal_server_error
  end
end
