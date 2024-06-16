class VehicleModelController < AuthenticationController
  include Paginatable

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
    vehiclde_models, meta = paginate(VehicleModel.all)
    render json: {data: vehiclde_models, pageable: meta}
  end

  def delete
    vm = VehicleModel.find_by(id: params[:id])
    vm.destroy!
    render json: {}, status: 204
  end

  def search
    substring_search_query = "%#{params[:query]}%"
    
    name_search, name_meta = paginate(VehicleModel.where("company_name LIKE :query", query: substring_search_query), params[:page], params[:per_page])
    model_search, model_meta = paginate(VehicleModel.where("model LIKE :query", query: substring_search_query), params[:page], params[:per_page])
    
    combined_results = (name_search + model_search).uniq
    combined_meta = {
      total_items: name_meta[:total_items] + model_meta[:total_items],
      total_pages: [name_meta[:total_pages], model_meta[:total_pages]].max,
      current_page: params[:page].to_i,
      per_page: params[:per_page].to_i
    }
    
    render json: { data: combined_results, pageable: combined_meta }, status: 200
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
