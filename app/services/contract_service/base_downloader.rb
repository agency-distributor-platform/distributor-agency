module ContractService
  class BaseDownloader
    attr_accessor :local_path, :content_type
    def initialize(registration_id, vehicle_obj)
      @vehicle_obj = vehicle_obj
      @registration_id = registration_id
      @filename = "#{@registration_id}.docx"
    end

    def execute
      get_content_type
      download_file 
      process_file
    end

    protected
    def get_content_type
      raise NotImplementedError, 'Subclasses must implement the content_type method'
    end
    
    def download_file
      @local_path = "/tmp/#{File.basename(@filename)}"
      @vehicle_obj.download_document_file(@filename, @local_path)
    end

    def process_file
      # Optionally overridden by subclasses
    end
  end
end
