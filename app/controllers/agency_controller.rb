require "#{Rails.root}/lib/all_business_logic"

class AgencyController < AuthenticationController

  include BusinessLogic
  attr_accessor :agency
  before_action :set_agency_obj

  def edit
    raise "False Pincode Format" if edit_params[:pincode].present? && is_false_pincode?(edit_params[:pincode])
    raise "False state value" if edit_params[:state].present? && is_false_state_or_ut?(edit_params[:state])
    agency.update(edit_params)
    agency_details = agency.as_json
    agency_details["id"] = convert_id_to_uuid(agency_details["id"])
    render json: agency_details, status: 201
  end

  def create_or_edit_vehicle_details
    render json: agency.update_item_details({item_type: "vehicle", data: vehicle_params}), status: 201
  end

  def bulk_upload_vehicle_details
    #TO-DO: File handling
    agency.bulk_upload({item_type: "vehicle", data: upload_details})
    render json: {}, status: 204
  end

  def get_sold_items
    render json: agency.get_sold_items(params[:item_type], params[:limit] || 10, params[:offset] || 0)
  end

  def get_distributors
    render json: agency.get_distributors(params[:limit] || 10, params[:offset] || 0)
  end

  def get_distributor
    details = agency.get_distributor(params[:distributor_id])
    if details.present?
      render json: details, status: 200
    else
      render json: {
        error_message: "Distributor id not linked to agency"
      }, status: 422
    end
  end

  def get_buyers
    render json: agency.get_buyers, status: 200
  end

  def get_buyer
    render json: agency.get_buyer(params[:buyer_id].to_i), status: 200
  end

  def get_vehicles
    render json: agency.get_items("vehicle"), status: 200
  end

  def get_vehicle_details
    render json: agency.get_item({item_type: "vehicle", item_id: params[:vehicle_id]}), status: 200
  end

  private

  def set_agency_obj
    record = $user.employer
    raise "Check user session" if record.blank? || $user.employer_type != "Agency"
    @agency = BusinessLogic::AgencyObj.new(record.as_json.deep_symbolize_keys)
  end

  def edit_params
    params.require(:agency_details).permit(:name, :email, :phone, :address, :city, :state, :pincode)
  end

  def vehicle_params
    params.require(:vehicle_details).permit(:id, :name, :registration_id, :chassis_id, :engine_id, :manufacturing_year, :cost_price, :cost_price_visibility_status, :status, :loan_or_agreement_number, :stock_entry_date, :comments, :location, :vehicle_model_id, :selling_price_visibility_status, :distributor_id, comments: []).to_h.deep_symbolize_keys
  end

end
