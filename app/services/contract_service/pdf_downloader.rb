module ContractService
  class PdfDownloader < BaseDownloader
    protected

    def s3_path
      "#{@registration_id}.pdf"
    end

    def get_content_type
      @content_type = 'application/pdf'
    end

    def process_file
      docx_downloader = DocxDownloader.new(@registration_id)
      docx_downloader.execute

      convert_docx_to_pdf if File.exist?(@local_path)
    end

    def convert_docx_to_pdf
      docx_path = download_file_from_s3("#{File.basename(@local_path, '.pdf')}.docx")
      pdf_path = "#{File.dirname(docx_path)}/#{File.basename(docx_path, '.docx')}.pdf"
      `libreoffice --headless --convert-to pdf #{docx_path} --outdir #{File.dirname(docx_path)}`
      S3Service.upload_file(pdf_path, s3_path) if File.exist?(pdf_path)
      @local_path = pdf_path
    end
  end
end
