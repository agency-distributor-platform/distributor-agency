require "#{Rails.root}/lib/all_business_logic"

class AgencyController < AuthenticationController

  include BusinessLogic
  attr_accessor :agency
  before_action :set_agency_obj

  def edit
    agency.update(edit_params)
    render json: agency.as_json, status: 201
  end

  def create_or_edit_vehicle_details
    agency.update_item_details({item_type: "vehicle", data: vehicle_params})
    render json: {}, status: 204
  end

  def sell_vehicle
    agency.sell_item({item_type: "vehicle", item_selling_details: item_selling_detail_params, buyer_id: params[:buyer_id]})
  end

  def bulk_upload_vehicle_details
    #TO-DO: File handling
    agency.bulk_upload({item_type: "vehicle", data: upload_details})
    render json: {}, status: 204
  end

  def get_sold_items
    render json: agency.get_sold_items(params[:item_type], params[:limit], params[:offset])
  end

  def get_distributors
    render json: agency.get_distributors(params[:limit], params[:offset])
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

  def distributors_linking
    BusinessLogic::DistributorObj.new({id: params[:distributor_id]}).link_to_agency(agency_obj)
    render json: {}, status: 204
  end

  def get_buyers
    render json: agency_obj.get_buyers, status: 200
  end

  def get_buyer
    render json: agency_obj.get_buyer(params[:buyer_id]), status: 200
  end

  def get_vehicles

  end

  private

  def set_agency_obj
    record = Agency.find_by(id: params[:agency_id])
    raise "Check agency id" if record.blank?
    @agency = BusinessLogic::AgencyObj.new(record.as_json.deep_symbolize_keys)
  end

  def edit_params
    params.require(:agency_details).permit(:name, :email, :phone)
  end

  def vehicle_params
    params.require(:vehicle_details).permit(:id, :name, :registration_id, :chassis_id, :engine_id, :manufacturing_year, :cost_price, :cost_price_visibility_status, :status, :loan_or_agreement_number, :stock_entry_date, :comments, :location, :vehicle_model_id, :selling_price_visibility_status, comments: [], :distributor_id).to_h.deep_symbolize_keys
  end

end
