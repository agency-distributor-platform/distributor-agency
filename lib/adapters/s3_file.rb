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

    def copy_object_to_new_folder(old_folder, new_folder)
      source_object = @bucket.object(old_folder)
      #root creation
      create_folder_if_not_created(new_folder)
      destination_object = @bucket.object(new_folder)

      children_keys = list_files(old_folder)
      children_key_mappings = {}
      children_keys.each { |child_key|
        children_key_mappings[child_key] = child_key.sub(old_folder, new_folder)
      }
      #copy children
      children_key_mappings.each { |source_key, destination_key|
        source_child_object = @bucket.object(source_key)
        destination_child_object = @bucket.object(destination_key)
        destination_child_object.copy_from(copy_source: "#{@bucket.name}/#{source_key}")
      }

    end

    def delete_file(key)
      bucket.object(key).delete
    end

    def folder_exists?(folder_name)
      bucket.objects(prefix: "#{folder_name}/").limit(1).any?
    end

    def download(s3_file_path, local_file_path)
      object = bucket.object(s3_file_path)
      object.download_file(local_file_path)
    end

  end
end
