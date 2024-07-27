class ContractController < AuthenticationController
  before_action :set_vehicle_obj
  before_action :set_agency_obj_only
  before_action :set_generate_contract_params, only: [:generate_contract]
  before_action :set_registration_id_param, only: [:download_as_docx, :download_as_pdf]


  def generate_contract
    contract_service = ContractService::GenerateDocx.new(params, @vehicle_obj)
    if contract_service.init
      render json: { message: 'Contract generated successfully' }, status: :ok
    else
      render json: { error: 'Failed to generate contract' }, status: :unprocessable_entity
    end
  end

  def download_as_docx
    downloader = ContractService::DocxDownloader.new(@params[:registration_id], @vehicle_obj)
    downloader.execute
    send_file(downloader.local_path, type: downloader.content_type, disposition: 'inline')
  end

  # def download_as_pdf
  #   downloader = ContractService::PdfDownloader.new(@params[:registration_id], @vehicle_obj)
  #   downloader.execute
  # end

  private

  def set_generate_contract_params
    @params = params.permit(
      :registration_id,
      :seller_title,
      :seller_name,
      :seller_address,
      :seller_age,
      :buyer_title,
      :buyer_name,
      :buyer_address,
      :buyer_age,
      :buyer_adhar_no,
      :vehicle_type,
      :vehicle_model,
      :registration_no,
      :engine_no,
      :chasis_no,
      :manufacturing_year,
      :selling_price,
      :witness_1_title,
      :witness_1_name,
      :witness_1_address,
      :witness_2_title,
      :witness_2_name,
      :witness_2_address,
      :buyer_sign,
      :seller_sign,
      :witness_1_sign,
      :witness_2_sign
    )
  end

  def set_registration_id_param
    @params = params.permit(:registration_id)
  end

  def set_vehicle_obj
    vehicle_id = Vehicle.where(registration_id: params[:registration_id]).first
    @vehicle_obj = ItemService::VehicleObj.new({id: vehicle_id})
  end 

end
