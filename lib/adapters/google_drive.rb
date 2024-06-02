# require 'google/apis/drive_v3'
# require 'googleauth'
# require 'googleauth/stores/file_token_store'
require 'fileutils'
require 'net/http'
require 'uri'

module Adapters
  class GoogleDrive
    OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
    APPLICATION_NAME = 'Web client 1'
    # CREDENTIALS_PATH = "#{config_folder}google_drive_credentials.json"
    # TOKEN_PATH = "#{config_folder}google_drive_token.yaml"
    # SCOPE = Google::Apis::DriveV3::AUTH_DRIVE_FILE

    #TO-DO: Shift get_dealdrive_folder_info, util methods for getting token and hitting routes and their related methods into class methods

    #TO-DO: Add retry mechanisms to hit route
    attr_reader :drive_service, :token

    def get_dealdrive_folder_info
      dealdrive_folder_id
    end

    # Initialize the API
    def initialize

    end

    # Create a folder
    def create_folder(folder_name, parent_folder_id = nil)
      file_metadata = {
        name: folder_name,
        mime_type: 'application/vnd.google-apps.folder'
      }
      file_metadata[:parents] = [parent_folder_id] if parent_folder_id
      get_token
      response = hit_route("Post", folder_creation_route, file_metadata)
      response
    end

    # Upload a file to a specific folder
    def upload_file(file, parent_folder_id=nil)
      file_metadata = {
        name: file.original_filename,
        mimeType: file.content_type,
      }
      file_content = file.read
      file_metadata[:parents] = [parent_folder_id] if parent_folder_id.present?
      get_token
      hit_route_for_upload_file_multipart("Post", upload_url, {
        metadata: file_metadata,
        content: file_content
      })
    end

    def find_folder(folder_name, parent_folder_id=nil)
      params = {
        fields: "files(id,name,kind,mimeType)"
      }
      params[:q] = URI.encode_www_form_component("parents in '#{parent_folder_id}'") if parent_folder_id.present?

      get_token
      folder_search_and_query_route(params)
      response = hit_route("Get", folder_search_and_query_route(params))

      response[:files].each { |file_obj|
        return file_obj if file_obj[:name] == folder_name
      }

      {}
    end

    def download_files(folder_id)
      files_list = get_files_from_folder(folder_id)
      get_token
      files = []
      files_list.map do |file|
        uri = URI.parse("https://www.googleapis.com/drive/v3/files/#{file['id']}?alt=media")
        request = Net::HTTP::Get.new(uri)
        request["Authorization"] = "Bearer #{token}"
        response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(request) }

        files.push({ name: file["name"], content: response.body })
      end

      files
    end

    private

    def get_files_from_folder(folder_id)
      uri = URI.parse("https://www.googleapis.com/drive/v3/files?q='#{folder_id}'+in+parents&fields=files(id,name)")
      request = Net::HTTP::Get.new(uri)
      get_token
      request["Authorization"] = "Bearer #{token}"
      request["Content-Type"] = "application/json"
      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(request) }
      JSON.parse(response.body)["files"]
    end

    def dealdrive_folder_id
      "1htynl7MG1a0fPp0GdNx_DE9N9Qbk6h_v"
    end

    def folder_creation_route
      "https://www.googleapis.com/drive/v3/files"
    end

    def folder_search_and_query_route(params)
      url = "https://www.googleapis.com/drive/v3/files"
      if params[:q].present?
        "#{url}?q=#{params[:q]}&fields=files(id,name,kind,mimeType)"
      else
        "#{url}?fields=files(id,name,kind,mimeType)"
      end
    end

    def upload_url
      "https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart"
    end

    def download_url(file_id)
      "https://www.googleapis.com/drive/v3/files/#{file_id}?alt=media"
    end

    # def config_folder
    #   "#{Rails.root}/config/"
    # end

    # def authorize
    #   client_id = Google::Auth::ClientId.from_file(CREDENTIALS_PATH)
    #   token_store = Google::Auth::Stores::FileToken_store.new(file: TOKEN_PATH)
    #   authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
    #   user_id = 'default'
    #   credentials = authorizer.get_credentials(user_id)
    #   if credentials.nil?
    #     url = authorizer.get_authorization_url(base_url: OOB_URI)
    #     puts 'Open the following URL in your browser and authorize the application.'
    #     puts url
    #     code = gets
    #     credentials = authorizer.get_and_store_credentials_from_code(
    #       user_id: user_id, code: code, base_url: OOB_URI
    #     )
    #   end
    #   credentials
    # end

    def get_token
      url = "https://oauth2.googleapis.com/token"
      params = {
        client_id:,
        client_secret:,
        grant_type: "refresh_token",
        refresh_token:
      }
      response = hit_route("Post", url, params)
      @token = response[:access_token]
    end

    def hit_route_for_upload_file_multipart(method, url, params)
      metadata = params[:metadata]
      file_content = params[:content]
      content_type = metadata[:mimeType]
      original_filename = metadata[:name]
      metadata = metadata.to_json

      boundary = "------RubyMultipartBoundary"
      body = []
      body << "--#{boundary}\r\n"
      body << "Content-Disposition: form-data; name=\"metadata\"\r\n"
      body << "Content-Type: application/json; charset=UTF-8\r\n\r\n"
      body << metadata
      body << "\r\n--#{boundary}\r\n"
      body << "Content-Disposition: form-data; name=\"file\"; filename=\"#{original_filename}\"\r\n"
      body << "Content-Type: #{content_type}\r\n\r\n"
      body << file_content
      body << "\r\n--#{boundary}--\r\n"

      uri = URI.parse(upload_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(uri.request_uri)
      request["Authorization"] = "Bearer #{token}"
      request["Content-Type"] = "multipart/related; boundary=#{boundary}"
      request.body = body.join
      response = http.request(request)
    end

    def hit_route(method, url, params={})
      uri_http = create_http_and_uri(url, params)
      uri = uri_http[:uri]
      http = uri_http[:http]
      request = "Net::HTTP::#{method}".constantize.new(uri.request_uri)
      if token.present?
        request["Authorization"] = "Bearer #{token}"
        request["Content-Type"] = "application/json"
      end

      request.body = params.to_json if method != "Get"

      response = http.request(request)
      JSON.parse(response.body).deep_symbolize_keys
    end

    def create_http_and_uri(url, params={})
      uri = URI.parse(url)
      uri.query = URI.encode_www_form(params) if params.present?
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      {
        uri:,
        http:
      }
    end

    #TO-DO: Shift to environment variables
    def client_id
      "194599003327-rs4qutjia8tc8rsbqe21l0f9f2spjqa3.apps.googleusercontent.com"
    end

    def client_secret
      "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"
    end

    def refresh_token
      "1//04WAZGBKwOANJCgYIARAAGAQSNgF-L9Ir3Vl2xyaDWkKHWIrLOxteEQkd3OPhVx0mT9JXRshDs2k80c6zEWX0HQTbmwQFAczJzQ"
    end


    # # Main script
    # begin
    #   # Create a parent folder
    #   parent_folder_id = create_folder(drive_service, 'Parent Folder')

    #   # Create a subfolder inside the parent folder
    #   child_folder_id = create_folder(drive_service, 'Child Folder', parent_folder_id)

    #   # Upload a file into the child folder
    #   file_path = 'path/to/your/file.txt'
    #   upload_file_id = upload_file(drive_service, file_path, child_folder_id)

    #   puts "Parent folder ID: #{parent_folder_id}"
    #   puts "Child folder ID: #{child_folder_id}"
    #   puts "Uploaded file ID: #{upload_file_id}"
    # rescue StandardError => e
    #   puts "An error occurred: #{e.message}"
    # end
  end
end
