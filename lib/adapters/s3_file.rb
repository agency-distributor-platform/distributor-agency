require 'aws-sdk-s3'

module Adapters
  class S3File

    attr_reader :s3, :bucket

    def initialize
      @s3 = Aws::S3::Resource.new
      @bucket = s3.bucket(bucket_name)
    end

    def upload_file(file_path, key)
      obj = bucket.object(key)
      obj.upload_file(file_path)
    end

    def public_url(key)
      bucket.object(key).public_url
    end

    def create_folder(folder_name)
      bucket.object("#{folder_name}/").put
    end

    def create_folder_if_not_created(folder_name)
      return if folder_exists?(folder_name)
      create_folder(folder_name)
    end

    def list_files(prefix = '')
      bucket.objects(prefix: prefix).collect(&:key).reject { |key| key == "#{prefix}/" }
    end

    def bucket_name
      "dealndrive"
    end

    def folder_exists?(folder_name)
      bucket.objects(prefix: "#{folder_name}/").limit(1).any?
    end

  end
end
