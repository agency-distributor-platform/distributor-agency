require "#{Rails.root}/lib/all_business_logic"

class BuyerController < AuthenticationController

  include BusinessLogic
  attr_accessor :buyer
  before_action :set_buyer_obj

  def edit
    buyer.create_or_update(edit_params)
    render json: buyer.as_json, status: 201
  end

  private

  def edit_params
    params.require(:buyer_details).permit(:name, :user_metadata)
  end

  def set_buyer_obj
    record = Buyer.find_by(id: params[:buyer_id])
    raise "Check buyer id" if record.blank?
    @buyer = BusinessLogic::BuyerObj.new(record.as_json.deep_symbolize_keys)
  end

end
