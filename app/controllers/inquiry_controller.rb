require "#{Rails.root}/lib/all_business_logic"

class InquiryController < AuthenticationController

  include BusinessLogic
  before_action :set_agency_or_distributor_or_salesperson_obj

  attr_reader :agency, :distributor, :salesperson

  def create
    render json: Inquiry.create!(create_params).as_json, status: :created
  end

  def list
    render json: Inquiry.where(agency_id: agency.record_id).as_json, status: :ok
  end

  private

  def set_agency_or_distributor_or_salesperson_obj
    raise "Check user session" if employer.blank?
    @agency = BusinessLogic::AgencyObj.new(employer.as_json.deep_symbolize_keys) if session_user_service.is_agency?
    if session_user_service.is_distributor?
      @distributor = BusinessLogic::DistributorObj.new(employer.as_json.deep_symbolize_keys)
      @agency = distributor.agency
    end
    @salesperson = BusinessLogic::SalespersonObj.new(employer.as_json.deep_symbolize_keys) if session_user_service.is_salesperson?
  end

  def create_params
    final_params = params.require(:inquiry).permit(:vehicle_model, :starting_price, :ending_price, :comments, :year)
    final_params[:agency_id] = agency.record_id
    final_params
  end

end
