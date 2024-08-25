require "#{Rails.root}/lib/all_business_logic"

class SalespersonController < AuthenticationController
  include Paginatable
  include BusinessLogic
  attr_accessor :salesperson
  before_action :set_salesperson_obj
  before_action :check_if_verified, except: [:edit]

  def edit
    raise "False Pincode Format" if edit_params[:pincode].present? && is_false_pincode?(edit_params[:pincode])
    raise "False state value" if edit_params[:state].present? && is_false_state_or_ut?(edit_params[:state])
    #TO-DO: Check details using of edit params using KYC verification
    salesperson.update(edit_params)
    render json: salesperson.as_json, status: 200
  end

  def get_sold_vehicles
    status = Status.find_by(name: "Sold")
    filter_hash = {item_type: "Vehicle", status: , salesperson: salesperson.record, page: params[:page], per_page: params[:per_page]}
    data, meta = ItemService::ItemStatusObj.get_items(filter_hash)
    render json: {
      data: data,
      pageable: meta
    }, status: :ok
  end

  def get_booked_vehicles
    status = Status.find_by(name: "Booked")
    filter_hash = {item_type: "Vehicle", status: , salesperson: salesperson.record}
    data, meta = ItemService::ItemStatusObj.get_items(filter_hash)
    render json: {
      data: data,
      pageable: meta
    }, status: :ok
  end

  def create_referral
    salesperson.create_referral(government_id_detail_params)
  end

  def raise_salesperson_linking_request
    salesperson.raise_linking_request(convert_uuid_to_id(params[:agency_id]))
    render json: {}, status: 204
  end

  def linked_agencies_vehicles
    linked_agencies = salesperson.linked_agencies
    filter_hash = {item_type: "Vehicle", agency: linked_agencies, per_page: params[:per_page], page: params[:page]}
    data, meta = ItemService::ItemStatusObj.get_items(filter_hash)
    render json: {data: data, pageable: meta}
  end

  def linked_agencies
    linked_agencies = []
    data, meta = paginate(salesperson.linked_agencies)
    data.as_json.each { |agency|
      agency.merge!(id: convert_id_to_uuid(agency['id']))
      linked_agencies.push(agency)
    }
    render json: {data: linked_agencies, pageable: meta}, status: 200
  end

  def list_agency_linking_requests
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

    data, meta = non_query_paginate(salesperson.linking_requests(filter_hash))
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

  private

  def government_id_detail_params
    params.permit(:buyer_government_document, :buyer_government_id)
  end

  def edit_params
    params.require(:salesperson_details).permit(:name, :email, :phone, :address, :city, :state, :pincode, :government_document, :government_document_identification)
  end

  def set_salesperson_obj
    record = Salesperson.find_by(id: user.employer_id)
    record = nil if !(user.employer_type == "Salesperson")
    raise "Check salesperson id" if record.blank?
    @salesperson = BusinessLogic::SalespersonObj.new(record.as_json.deep_symbolize_keys)
  end

  def check_if_verified
    not_verified_error_message = salesperson.is_verified? ? nil : "Not Verified"
    raise not_verified_error_message if not_verified_error_message.present?
  end

end
