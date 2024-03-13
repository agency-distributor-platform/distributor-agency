require "#{Rails.root}/lib/all_business_logic"

class ItemController < ApplicationController

  attr_accessor :obj_class

  def sell_vehicle
    persona_id = Persona.find_by(item_selling_detail_params[:persona]).id
    derive_obj_class(params[:item_type])
    obj_class.new({id: item_selling_detail_params[:id]}).sell({item_selling_price: item_selling_detail_params[:selling_price], persona_id: , buyer_details: buyer_detail_params})
    render json: {}, status: 204
  end

  private

  def derive_obj_class(item_type)
    @obj_class = "BusinessLogic::#{item_type.capitalize}Obj".constantize
  end

  def item_selling_detail_params
    params.require(:item_selling_details).permit(:id, :selling_price, :persona).to_h.deep_symbolize_keys
  end

  def buyer_detail_params
    params.require(:buyer_details).permit(:id, :name, user_metadata: {}).to_h.deep_symbolize_keys
  end
end
