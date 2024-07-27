require 'open3'

module ContractService
  class GenerateDocx
    def initialize(params, vehicle_obj)
      @params = params
      @vehicle_obj = vehicle_obj
      prepare_replacement
      input_folder = 'app/services/contract_service'
      input_file = 'template.docx'
      output_folder = '/tmp'
      @output_file = "#{@params['registration_id']}.docx"
      @docx_input_path = Rails.root.join(input_folder, input_file)
      @docx_output_path = Rails.root.join(output_folder,@output_file)
    end

    def init
      status = generate_docx
      upload_contract_to_s3 if status 
      return status
    end

    private

    def generate_docx
      replacements_json = @text_replacements.to_json
      image_replacements = @image_replacements.to_json
      script_path = Rails.root.join('scripts', 'generate_docx.py')
      command = "python3 #{script_path} #{@docx_input_path} #{@docx_output_path} '#{replacements_json}' '#{image_replacements}'"
      stdout, stderr, status = Open3.capture3(command)
      Rails.logger.error("Error running generate_docx.py: #{stderr}") unless status.success?
      return status
    end

    def prepare_replacement
      @text_replacements = {}
      @image_replacements = {}

      text_keys_array = %w[
        seller_title seller_name seller_address seller_age buyer_title buyer_name buyer_address
        buyer_age buyer_adhar_no vehicle_type vehicle_model
        registration_id engine_no chasis_no manufacturing_year selling_price
        witness_1_title witness_1_name witness_1_address 
        witness_2_title witness_2_name witness_2_address
      ]

      image_keys_array = %w[buyer_sign seller_sign witness_1_sign witness_2_sign]

      @text_replacements["date"] =  Time.now.strftime("%B %d, %Y")
      text_keys_array.each do |key|
        @text_replacements["#{key}"] = @params[key] if @params[key].present?
      end


      image_keys_array.each do |key|
        @image_replacements["{{#{key}}}"] = @params[key].path if @params[key].present?
      end 
    end

    def upload_contract_to_s3
      @vehicle_obj.upload_document_file(@docx_output_path, @output_file)
    end
  end
end
