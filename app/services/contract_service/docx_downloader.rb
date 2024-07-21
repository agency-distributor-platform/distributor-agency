# app/services/contract_service/docx_downloader.rb
module ContractService
  class DocxDownloader < BaseDownloader
    protected
    def get_content_type
      @content_type = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
    end
  end
end
