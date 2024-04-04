require "#{Rails.root}/lib/all_business_logic"

class VehicleController < AuthenticationController

  include BusinessLogic
  attr_accessor :agency, :distributor, :salesperson
  before_action :set_agency_obj_only, only: [:create_or_edit_vehicle_details]
  before_action :set_agency_or_distributor_or_salesperson_obj, only: [:get_vehicles, :get_vehicle_details]

  def create_or_edit_vehicle_details
    render json: agency.update_item_details({item_type: "vehicle", data: vehicle_params}), status: 201
  end

  def get_vehicles
    status = Status.find_by(name: params[:status])
    if salesperson.present?
      render json: BusinessLogic::VehicleObj.get_all_vehicles(status)
    else
      render json: BusinessLogic::VehicleObj.get_agency_vehicles(status, agency)
    end
  end

  def get_vehicle_details
    if salesperson.present?
      render json:
  end

  private

  def set_agency_obj
    record = $user.employer
    raise "Check user session" if record.blank? || $user.employer_type != "Agency"
    @agency = BusinessLogic::AgencyObj.new(record.as_json.deep_symbolize_keys)
  end

  def set_agency_or_distributor_or_salesperson_obj
    record = $user.employer
    raise "Check user session" if record.blank?
    @agency = BusinessLogic::AgencyObj.new(record.as_json.deep_symbolize_keys) if $user.employer_type == "Agency"
    if $user.employer_type == "distributor"
      @distributor = BusinessLogic::DistributorObj.new(record.as_json.deep_symbolize_keys)
      @agency = distributor.agency
    end
    @salesperson = BusinessLogic::SalespersonObj.new(record.as_json.deep_symbolize_keys) if $user.employer_type == "salesperson"
  end

  def vehicle_params
    params.require(:vehicle_details).permit(:id, :registration_id, :chassis_id, :engine_id, :manufacturing_year, :cost_price, :loan_or_agreement_number, :stock_entry_date, :comments, :location, :vehicle_model_id, :distributor_id, comments: [], :city, :state, :pincode).to_h.deep_symbolize_keys
  end

end
