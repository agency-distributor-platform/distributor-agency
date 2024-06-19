module UploadService
  class BulkUpload
    attr_accessor :agency_id

    def download_template
      file = 'vehicle_details_template.xlsx'
      records = [Constants::VEHICLE_DETAILS_UPLOAD_HEADERS]
      Utils::FileParserFactory.get_parser('xlsx').write(file, records)

      file
    end

    def upload_vehicle_details(params, agency_id)
      file = params[:file]
      @agency_id = agency_id
      reader = Utils::FileParserFactory.get_parser('xlsx').get_reader(file.path)

      reader.basic_validation
      reader.headers_validation(Constants::VEHICLE_DETAILS_UPLOAD_HEADERS)

      records = reader.read

      prepare_upsert_params(records)

      #to do : replace raw sql with model queries
      # to do : refactor code, move upsert methods to new class
      ActiveRecord::Base.transaction do
        prepare_reg_ids_in_conditions

        upsert_vehicle_models
        vehicle_models_ids_mapping = get_vehicle_model_ids
        update_vehicle_model_id_in_vehicles(vehicle_models_ids_mapping)

        upsert_vehicles
        vehicle_id_mapping = get_vehicles_id
        update_item_id_in_item_mapping(vehicle_id_mapping)

        upsert_item_mapping_records
        reg_id_to_item_id = get_item_mapping_id
        update_transaction_params(reg_id_to_item_id)

        upsert_transactions
        reg_id_to_transaction_id = get_transaction_id_mapping
        update_sell_transaction_params(reg_id_to_transaction_id)

        upsert_sell_transactions
      end
      return {code: 200}, 200
    rescue UploadService::InvalidStatusError => e
      return {
        error: e.message
      }, 422
    rescue Utils::FileParserError => e
      return {
        error: e.message
      }, 400
    rescue ActiveRecord::RecordNotUnique => e
      return {
        error: "A unique key violation occurred: #{e.message}"
      }, 422
    rescue StandardError => e
      return {
        error: "An unexpected error occurred: #{e.message}, #{e.backtrace}"
      }, 500
    end

    def prepare_reg_ids_in_conditions
      @quoted_registration_ids = @vehicles.map { |vehicle|
      ActiveRecord::Base.connection.quote(vehicle[:registration_id])}.join(',')
    end

    def upsert_vehicle_models
      VehicleModel.upsert_all(@vehicle_models)
    end

    def get_vehicle_model_ids
      VehicleModel.pluck(:company_name, :model, :id).each_with_object({}) do |(company, model, id), hash|
        hash["#{company}-#{model}"] = id
      end
    end

    def update_vehicle_model_id_in_vehicles(mapping)
      @vehicles.each do |vehicle|
        vehicle[:vehicle_model_id] = mapping[vehicle[:company_name_model]]
        vehicle.delete(:company_name_model)
      end
    end

    def upsert_vehicles
      Vehicle.upsert_all(@vehicles)
    end

    def get_vehicles_id
      reg_ids = @vehicles.map { |record| record[:registration_id] }
      mapping = Vehicle.where(registration_id: reg_ids).pluck(:registration_id, :id).to_h
    end

    def update_item_id_in_item_mapping(mapping)
      @item_mapping_records.each do |item_mapping|
        item_mapping[:item_id] = mapping[item_mapping[:registration_id]]
        item_mapping.delete(:registration_id)
      end
    end

    def upsert_item_mapping_records
      ItemStatus.upsert_all(@item_mapping_records)
    end

    def get_item_mapping_id
      query = "
        SELECT vehicles.registration_id as registration_id, item_mapping_records.id as item_mapping_record_id
        FROM item_mapping_records
        INNER JOIN vehicles ON item_mapping_records.item_type = 'Vehicle' AND item_mapping_records.item_id = vehicles.id
        WHERE vehicles.registration_id IN (#{@quoted_registration_ids})
      "
      ActiveRecord::Base.connection.select_all(query).each_with_object({}) do |row, hash|
        hash[row['registration_id']] = row['item_mapping_record_id']
      end
    end

    def update_transaction_params(mapping)
      @transactions.each do |transaction|
        transaction[:item_mapping_record_id] = mapping[transaction[:registration_id]]
        transaction.delete(:registration_id)
      end
    end

    def upsert_transactions
      Transaction.upsert_all(@transactions)
    end

    def get_transaction_id_mapping
      query = "
        SELECT transactions.id as transaction_id, vehicles.registration_id as registration_id
        FROM item_mapping_records
        INNER JOIN vehicles ON item_mapping_records.item_type = 'Vehicle' AND item_mapping_records.item_id = vehicles.id
        INNER JOIN transactions ON transactions.item_mapping_record_id = item_mapping_records.id
        WHERE vehicles.registration_id IN (#{@quoted_registration_ids})
      "
      ActiveRecord::Base.connection.select_all(query).each_with_object({}) do |row, hash|
        hash[row['registration_id']] = row['transaction_id']
      end
    end

    def update_sell_transaction_params(mapping)
      @sell_transactions.each do |sell_transaction|
        sell_transaction[:transaction_id] = mapping[sell_transaction[:registration_id]]
        sell_transaction.delete(:registration_id)
      end
    end

    def upsert_sell_transactions
      SellingTransaction.upsert_all(@sell_transactions)
    end

    def prepare_upsert_params(records)
      @vehicles = []
      @vehicle_models = []
      @item_mapping_records = []
      @transactions = []
      @sell_transactions = []
      @statuses = Hash.new
      Status.all.collect{|status| @statuses[status.name] = status.id}
      records.each do |record|
        @vehicle_models << transform_vehicle_model_data(record)
        @vehicles << transform_vehicle_data(record)
        @item_mapping_records << transform_item_mapping_data(record)
        @transactions << transform_transactions_data(record)
        @sell_transactions << transform_sell_transactions_data(record)
      end
    end

    def transform_vehicle_model_data(record)
      {
        company_name: record["Company"],
        model: record["Model"]
      }
    end

    def transform_vehicle_data(record)
      city = record["City"].titlecase if record["City"].present?
      state = record["State"].titlecase if record["State"].present?
      {
        company_name_model: "#{record["Company"]}-#{record["Model"]}",
        fin_company_name: record["Finance Company Name"],
        loan_or_agreement_number: record["Loan Agreement Number"],
        registration_id: record["Reg No"],
        engine_id: record["Engine No"],
        chassis_id: record["Chasis No"],
        manufacturing_year: record["Year Of Manufacturing"],
        location: record["Location"],
        city: city,
        state: state,
        pincode: record["Pincode"],
        stock_entry_date: record["Stock Entery Date"],
        cost_price: record["Buy Price"],
        expenses: record["Expenses"],
        comments: record["Remarks"],
        kms_driven: record["KMS Driven"]
      }
    end

    def transform_item_mapping_data(record)
      status_id = @statuses[record["Status"]]
      raise UploadService::InvalidStatusError.new("Invalid status - #{record["Status"]}") if status_id.nil?
      {
        item_type: 'Vehicle',
        registration_id: record["Reg No"],
        status_id: status_id,
        agency_id: agency_id,
        distributor_share: record["Commission"]
      }
    end

    def transform_transactions_data(record)
      {
        transaction_date: Time.current,
        payment_transaction_id: 'Cash',
        registration_id: record["Reg No"]
      }
    end

    def transform_sell_transactions_data(record)
      {
        selling_price: record["Sale Price"],
        due_price: record["Due"],
        selling_persona_type: 'Agency',
        registration_id: record["Reg No"]
      }
    end
  end
end
