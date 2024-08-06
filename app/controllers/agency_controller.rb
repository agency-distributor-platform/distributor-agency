require "#{Rails.root}/lib/all_business_logic"

class AgencyController < AuthenticationController

  include Paginatable
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

  def get_sold_vehicles
    status = Status.find_by(name: "Sold")
    filter_hash = {item_type: "Vehicle", status: , agency: agency.record}
    filter_hash[:page] = params[:page]
    filter_hash[:per_page] = params[:per_page]
    data, meta = ItemService::ItemStatusObj.get_items(filter_hash)
    render json: {data: data, pageable: meta}
  end

  def get_booked_vehicles
    status = Status.find_by(name: "Booked")
    filter_hash = {item_type: "Vehicle", status: , agency: agency.record}
    filter_hash[:page] = params[:page]
    filter_hash[:per_page] = params[:per_page]
    data, meta = ItemService::ItemStatusObj.get_items(filter_hash)
    render json: {data: data, pageable: meta}
  end

  #implement list_salesperson_linking_requests
  def list_salesperson_linking_requests
    if params[:type_of_requests].blank?
      raise "Type of requests not present"
    end
    linkings = []

    is_verified = params[:type_of_requests] == "approved" ? true : false
    rejected = params[:type_of_requests] == "rejected" ? true : false
    if params[:type_of_requests] == "pending"
      is_verified = false
      rejected = false
    end

    filter_hash = {}

    if is_verified
      filter_hash[:is_verified] = true
    elsif rejected
      filter_hash[:rejected] = true
    else
      filter_hash[:is_verified] = false
      filter_hash[:rejected] = false
    end

    data, meta = non_query_paginate(agency.list_salesperson_linking_requests(filter_hash))
    data.each { |linking|
      linking[:salesperson_id] = convert_id_to_uuid(linking["salesperson_id"])
      linking[:agency_id] = convert_id_to_uuid(linking["agency_id"])
      linking[:agency_details] = Agency.find_by(id: linking["agency_id"]).as_json
      linking[:salesperson_details] = Salesperson.find_by(id: linking["salesperson_id"]).as_json
      linkings.push(linking)
    }

    render json: {
      data: linkings,
      pageable: meta,
    }, status: 200
  end

  def approve_salesperson_linking_request
    agency.approve_salesperson_linking_request(params[:linking_id], params[:approval])
    render json: {}, status: 204
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

end
