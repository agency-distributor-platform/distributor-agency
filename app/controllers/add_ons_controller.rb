class AddOnsController < AuthenticationController
  attr_reader :agency
  before_action :set_add_on, only: [:update, :destroy]
  before_action :set_agency_obj_only, only: [:create, :update, :destroy]
  before_action :set_vehicle_obj, only: [:create, :update, :destroy]
  before_action :set_added_photos, only: [:create, :update]
  before_action :set_deleted_photos, only: [:update, :destroy]


  def index
    item_id = params[:item_id]
    render json: {data: AddOn.where(item_mapping_record_id: item_id)}
  end

  def create 
    @add_on = AddOn.new(add_on_params)
    if @add_on.save
      @vehicle_obj.upload_add_on_photos(@added_photos, @add_on.id) if @added_photos.present?
      render status: :created
    else
      render json: {errors: @add_on.errors}, status: :unprocessable_entity
    end
  end 

  def update
    if @add_on.update(add_on_params)
      @vehicle_obj.delete_add_on_photos(@deleted_photos) if @deleted_photos.present? 
      @vehicle_obj.upload_add_on_photos(@added_photos, @add_on.id) if @added_photos.present?
      render json: @add_on, status: :ok 
    else
      render json: @add_on.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @add_on.destroy
    @vehicle_obj.delete_add_on_photos(@deleted_photos) if @deleted_photos.present?
    head :no_content
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'AddOn not found' }, status: :not_found
  end

  private 
  def set_add_on
    @add_on = AddOn.find(params[:id])
  end

  def set_added_photos 
    @added_photos = params[:add_ons][:added_photos]
  end 

  def set_deleted_photos
    @deleted_photos = params[:add_ons][:deleted_photos]
  end 

  def add_on_params
    params.require(:add_ons).permit(:amount, :biller_name, :description, :biller_location, :biller_phone, :item_mapping_record_id)
  end

  def set_vehicle_obj
    vehicle_id = ItemStatus.find(params[:add_ons][:item_mapping_record_id]).item_id
    @vehicle_obj = ItemService::VehicleObj.new({id: vehicle_id})
  end 
end 
