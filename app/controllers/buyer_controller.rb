require "#{Rails.root}/lib/all_business_logic"

class BuyerController < AuthenticationController

  include Paginatable
  include BusinessLogic
  attr_accessor :buyer
  before_action :set_buyer_obj, only: [:get_buyer, :edit]

  def get_buyers
    buyers = []
    records, meta = paginate(employer.buyers)
    records.each { |buyer|
      buyers.push(buyer.as_json_with_converted_id)
    }
    render json: {
      data: buyers, 
      pageable: meta
    }, status: :ok
  end

  def get_buyer
    if buyer.present?
      render json: buyer.as_json, status: :ok
    else
      render json: {"error": "Not Authorized"}, status: 401
    end
  end

  def edit
    if buyer.present?
      editing_details = edit_params
      raise "False Pincode Format" if editing_details[:pincode].present? && is_false_pincode?(editing_details[:pincode])
      raise "False state value" if editing_details[:state].present? && is_false_state_or_ut?(editing_details[:state])
      buyer.create_or_update(editing_details)
      render json: buyer.as_json, status: :created
    else
      render json: {"error": "Not Authorized"}, status: 401
    end
  end

  private

  def edit_params
    params.require(:buyer_details).permit(:name, :user_metadata, :address, :city, :state, :pincode, :addhar, :pan, :father_name, :mother_name)
  end

  def set_buyer_obj
    record = Buyer.find_by(id: convert_uuid_to_id(params[:buyer_id]))
    raise "Check buyer id" if record.blank?
    @buyer = BusinessLogic::BuyerObj.new(record.as_json.deep_symbolize_keys) if employer.buyer_exists?(record)
  end

end
