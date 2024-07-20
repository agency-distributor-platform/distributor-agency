require "#{Rails.root}/lib/all_business_logic"

class SalespersonController < AuthenticationController
  include BusinessLogic
  attr_accessor :salesperson
  before_action :set_salesperson_obj
  before_action :check_if_verified, except: [:edit]

  def edit
    raise "False Pincode Format" if edit_params[:pincode].present? && is_false_pincode?(edit_params[:pincode])
    raise "False state value" if edit_params[:state].present? && is_false_state_or_ut?(edit_params[:state])
    salesperson.update(edit_params)
    render json: salesperson.as_json, status: 200
  end

  def get_sold_vehicles
    status = Status.find_by(name: "Sold")
    filter_hash = {item_type: "Vehicle", status: , salesperson: salesperson.record}
    render json: ItemService::ItemStatusObj.get_items(filter_hash)
  end

  def get_booked_vehicles
    status = Status.find_by(name: "Booked")
    filter_hash = {item_type: "Vehicle", status: , salesperson: salesperson.record}
    render json: ItemService::ItemStatusObj.get_items(filter_hash)
  end

  def create_referral
    salesperson.create_referral(government_id_detail_params)
  end

  private

  def government_id_detail_params
    params.permit(:buyer_government_document, :buyer_government_id)
  end

  def edit_params
    params.require(:salesperson_details).permit(:name, :email, :phone, :address, :city, :state, :pincode)
  end

  def set_salesperson_obj
    record = Salesperson.find_by(id: user.employer_id)
    record = nil if !(user.employer_type == "Salesperson")
    raise "Check salesperson id" if record.blank?
    @salesperson = BusinessLogic::SalespersonObj.new(record.as_json.deep_symbolize_keys)
  end

  def check_if_verified
    salesperson.is_verified? ? nil : raise "Not Authenticated"
  end

end
