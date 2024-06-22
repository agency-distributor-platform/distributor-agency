class AddOnsController < AuthenticationController
  before_action :set_add_on, only: [:update, :destroy]

  def index
    item_id = params[:item_id]
    render json: {data: AddOn.where(item_mapping_record_id: item_id)}
  end

  def create 
    @add_on = AddOn.new(add_on_params)

    if @add_on.save
      render status: :created
    else
      render json: {errors: @add_on.errors}, status: :unprocessable_entity
    end
  end 

  def update
    if @add_on.update(add_on_params)
      render json: @add_on, status: :ok 
    else
      render json: @add_on.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @add_on.destroy
    head :no_content
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'AddOn not found' }, status: :not_found
  end

  private 
  def set_add_on
    @add_on = AddOn.find(params[:id])
  end

  def add_on_params
    params.require(:add_ons).permit(:amount, :biller_name, :description, :biller_location, :biller_phone, :item_mapping_record_id)
  end
end 
