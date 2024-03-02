require "#{Rails.root}/lib/all_business_logic"

class DistributorController < ApplicationController

  include BusinessLogic
  attr_accessor :distributor
  before_action :set_distributor_obj

  def get_sold_items
    render json: distributor.get_sold_items(params[:item_type], params[:limit] || 10, params[:offset] || 1)[:distributor_sold_items].first[:item_details]
  end

  def get_buyers
    render json: distributor.get_buyers, status: 200
  end

  def get_buyer
    render json: distributor.get_buyer(params[:buyer_id].to_i), status: 200
  end

  def get_vehicles
    render json: distributor.get_items("vehicle"), status: 200
  end

  def get_vehicle_details
    render json: distributor.get_item({item_type: "vehicle", item_id: params[:vehicle_id]}), status: 200
  end

  private

  def set_distributor_obj
    record = Distributor.find_by(id: params[:distributor_id])
    raise "Check distributor id" if record.blank?
    @distributor = BusinessLogic::DistributorObj.new(record.as_json.deep_symbolize_keys)
  end
end
