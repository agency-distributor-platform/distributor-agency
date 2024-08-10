require "set"
require_relative "./../../lib/utils/pagination.rb"
require "#{Rails.root}/lib/all_business_logic"
require "#{Rails.root}/lib/utils/filter_hash_to_filter_converter"
require 'mime/types'

class VehiclesController < AuthenticationController

  include BusinessLogic
  include Utils
  include Utils::Pagination
  attr_reader :agency, :distributor, :salesperson, :item_obj
  before_action :set_agency_obj_only, only: [:create_or_edit_vehicle_details, :assign_vehicle]
  before_action :set_agency_or_distributor_or_salesperson_obj, only: [:get_vehicles, :get_vehicle_details, :transact_vehicle, :get_transaction_details, :get_vehicle_transactions, :filter_results]

  def create_or_edit_vehicle_details
    record_id = vehicle_params.delete(:id)
    check_pincode(vehicle_params[:pincode])
    check_state(vehicle_params[:state])
    #TO-DO: Move to a function
    vehicle_obj = ItemService::VehicleObj.new({id: record_id})
    vehicle_obj.create_or_update(vehicle_params, agency.record_id)
    render json: {}
  end

  def photos
    vehicle_obj = ItemService::VehicleObj.new({id: params[:vehicle_id]})
    render json: vehicle_obj.get_photos, status: :ok
  end

  def get_vehicles
    status_name = ["Added", "Available", "Booked"]
    status = Status.where(name: status_name)
    # status = Status.find_by(name: params[:status])
    if salesperson.present?
      filter_hash = {item_type: "Vehicle"}
      filter_hash[:status] = status if status.present?
    else
      filter_hash = {item_type: "Vehicle", agency: agency.record}
      filter_hash[:status] = status if status.present?
    end
    filter_hash[:page] = params[:page]
    filter_hash[:per_page] = params[:per_page]
    data, meta = ItemService::ItemStatusObj.get_items(filter_hash, "DESC")
    render json: {data: data, pageable: meta}
  end

  def get_vehicle_details
    filter_hash = {item_type: "Vehicle", item_id: params[:vehicle_id]}
    filter_hash[:agency] = agency.record if salesperson.blank?
    filter_hash[:distributor] = distributor if distributor.present?
    render json: ItemService::ItemStatusObj.get_items(filter_hash).first
  end

  def assign_vehicle
    vehicle_id = params[:vehicle_id]
    item_status_obj = ItemService::VehicleObj.new({id: vehicle_id}).item_status_obj
    distributor_obj = BusinessLogic::DistributorObj.new({id: convert_uuid_to_id(params[:distributor_id])})
    if distributor_obj.record_present?
      item_status_obj.assign_item(distributor_obj)
      render json: {}, status: 204
    else
      render json: {
        error: "Distributor not found"
      }, status: 404
    end
  end

  def transact_vehicle
    verify_vehicle_id(params[:vehicle_id])
    transaction_type = "#{params[:transaction_type].capitalize}"
    verify_transaction_type(transaction_type)
    item_obj.transact_item({
      buyer_details: buyer_params,
      transaction: transaction_params,
      transaction_type: ,
      transaction_type_details: transaction_type_params
    })
    render json:{message: 'success'}, status: 204
  end

  def get_buyer_details
    vehicle_obj = ItemService::VehicleObj.new({id: params[:vehicle_id]})
    vehicle_item_status_obj = vehicle_obj.item_status_obj
    buyer_details, buyer_photos = vehicle_item_status_obj.get_buyer_details
    render json: {buyer_details: , buyer_photos: }, status: 200
  end 

  def get_vehicle_transactions
    vehicle_obj = ItemService::VehicleObj.new({id: params[:vehicle_id]})
    vehicle_item_status_obj = vehicle_obj.item_status_obj
    if verify_session_user_for_item_status(vehicle_item_status_obj)
      data, meta = vehicle_item_status_obj.get_transactions(params[:page], params[:per_page])
      render json: {data: data, pageable: meta}, status: 200
    else
      render json: {
        "error" => "Forbidden"
      }, status: 403
    end
  end


  def delete
    vehicle = Vehicle.find_by(id: params[:vehicle_id])
    delete_status = vehicle.delete rescue nil
    if delete_status.present?
      render json: {}
    else
      render json:{"error" => "Internal Server Error"}, status: 500
    end
  end

  def filter_results
    filter_hash = filter_params[:filters]
    filter_objs = Utils::FilterHashToFilterConverter.convert(filter_hash, Vehicle, {
      expenses: :item_status
    })

    records = nil
    filter_objs.each_with_index { |filter_obj, index|
      filter_records = filter_obj.apply_filter
      records = records.nil? ? Set.new(filter_records) : records & Set.new(filter_records)
    }

    ordered_records = records.sort_by { |record| -record.id }
    item_status_records = []
    ordered_records.to_a.each { |record|
      item_status_record = record.item_status
      item_status_records.push(ItemService::ItemStatusObj.get_item_hash(item_status_record))
    }

    data, pageable = non_query_paginate(item_status_records, params[:page] || 1, params[:per_page] || 15)

    render json: {
      data: ,
      pageable:
    }
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

  def vehicle_params
    params.require(:vehicle_details).permit(:id, :registration_id, :chassis_id, :engine_id, :manufacturing_year, :cost_price, :loan_or_agreement_number, :stock_entry_date, :comments, :location, :vehicle_model_id, :city, :state, :pincode, :comments, :kms_driven, :category, photos: [], deleted_photos: []).to_h.deep_symbolize_keys
  end

  def check_pincode(pincode)
    raise "Please check pincode" if pincode.present? && AddressUtils.is_false_pincode?(pincode)
  end

  def check_state(state_or_ut)
    raise "Please check state/union territory" if state_or_ut.present? && AddressUtils.is_false_state_or_ut?(state_or_ut)
  end

  def verify_vehicle_id(vehicle_id)
    @item_obj = ItemService::VehicleObj.new({id: vehicle_id})
    raise "Mismatch between vehicle id and persona" if !((distributor.present? && distributor.is_valid_vehicle?(item_obj)) || agency.is_valid_vehicle?(item_obj))
  end

  def verify_transaction_type(transaction_type_value)
    raise "Wrong transaction type" if !["Selling", "Booking"].include?(transaction_type_value)
  end

  def buyer_params
    params.require(:buyer_details).permit(:id, :name, :user_metadata, :address, :city, :state, :pincode, :addhar, :pan, :father_name, :mother_name, :phone, :title, :pancard_photo, :adharcard_front_photo, :adharcard_back_photo, :signature_photo)
  end

  def transaction_params
    transaction_record_details = params.require(:transaction_details).permit(:transaction_date, :payment_transaction_id)
    if transaction_record_details[:transaction_date].blank?
      transaction_record_details[:transaction_date] = DateTime.now
    else
      year, month, day = transaction_record_details[:transaction_date].split("-").map(&:to_i)
      transaction_record_details[:transaction_date] = DateTime.new(year, month, day)
    end
    transaction_record_details
  end

  def transaction_type_params
    transaction_details = params.require(:transaction_details)
    transaction_details.delete(:transaction_type)
    transaction_details.delete(:transaction_date)
    transaction_details.delete(:payment_transaction_id)
    booking_transactions = transaction_details.permit(:booking_price, :booking_persona_type).to_h
    booking_transactions.blank? ? transaction_details.permit(:selling_price, :paid_amount, :selling_persona_type) : booking_transactions
  end

  def verify_session_user_for_item_status(item_status_obj)
    (session_user_service.is_agency? && item_status_obj.agency.eql?(agency)) || (session_user_service.is_distributor? && item_status_obj.distributor.eql?(distributor)) || (session_user_service.is_salesperson? && item_status_obj.salesperson.record == salesperson.record)
  end

  def filter_params
    params.require(:vehicles).permit(filters: {}).to_h.deep_symbolize_keys
  end

end
