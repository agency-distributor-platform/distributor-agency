class VehicleModelController < AuthenticationController

  def create
    render json: VehicleModel.create!(vehicle_model_params).as_json, status: 201
  end

  def edit
    vm = VehicleModel.find_by(id: params[:id])
    vm.model = vehicle_model_params[:model] if vehicle_model_params[:model].present?
    vm.company_name = vehicle_model_params[:company_name] if vehicle_model_params[:company_name].present?
    vm.save!
    render json: vm.as_json, status: 201
  end

  def show
    render json: VehicleModel.find_by(id: params[:id]).as_json
  end

  def list
    render json: VehicleModel.all.as_json
  end

  def delete
    vm = VehicleModel.find_by(id: params[:id])
    vm.destroy!
    render json: {}, status: 204
  end

  private

  def vehicle_model_params
    params.require(:vehicle_model_details).permit(
      :company_name,
      :model,
      :manufactoring_year
    )
  end

end
