require "#{Rails.root}/lib/all_business_logic"

class DistributorController < AuthenticationController

  include BusinessLogic
  attr_accessor :distributor
  before_action :set_distributor_obj

  def edit
    raise "False Pincode Format" if edit_params[:pincode].present? && is_false_pincode?(edit_params[:pincode])
    raise "False state value" if edit_params[:state].present? && is_false_state_or_ut?(edit_params[:state])
    distributor.update(edit_params)
    render json: distributor.as_json, status: 201
  end

  def get_sold_items
    sold_items = distributor.get_sold_items(params[:item_type], params[:limit] || 10, params[:offset] || 1)[:distributor_sold_items].first[:item_details] rescue []
    render json: sold_items
  end

  def get_buyers
    render json: distributor.get_buyers, status: 200
  end

  def get_buyer
    render json: distributor.get_buyer(params[:buyer_id].to_i), status: 200
  end

  # def get_vehicles
  #   render json: distributor.get_items("vehicle"), status: 200
  # end

  def get_vehicle_details
    render json: distributor.get_item({item_type: "vehicle", item_id: params[:vehicle_id]}), status: 200
  end

  def agency_linking
    distributor.link_to_agency(BusinessLogic::AgencyObj.new({id: Agency.find_by(id: convert_uuid_to_id(params[:agency_uuid])).id }))
    render json: {}, status: 204
  end

  def get_sold_vehicles
    status = Status.find_by(name: "Sold")
    filter_hash = {item_type: "Vehicle", status: , distributor: distributor.record}
    render json: ItemService::ItemStatusObj.get_items(filter_hash)
  end

  def get_booked_vehicles
    status = Status.find_by(name: "Booked")
    filter_hash = {item_type: "Vehicle", status: , distributor: distributor.record}
    render json: ItemService::ItemStatusObj.get_items(filter_hash)
  end

  private

  def edit_params
    params.require(:distributor_details).permit(:name, :email, :phone, :address, :city, :state, :pincode)
  end

  def set_distributor_obj
    record = Distributor.find_by(id: user.employer_id)
    record = nil if !(user.employer_type == "Distributor")
    raise "Check distributor id" if record.blank?
    @distributor = BusinessLogic::DistributorObj.new(record.as_json.deep_symbolize_keys)
  end
end
