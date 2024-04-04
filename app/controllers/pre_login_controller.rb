class PreLoginController < ApplicationController

  LIMIT = 25
  private_constant :LIMIT

  def list_agencies
    agencies = Agency.all.limit(LIMIT).select(:id, :name, :email, :phone).as_json
    agencies.each { |agency|
      agency["id"] = convert_id_to_uuid(agency["id"])
    }
    render json: agencies
  end

  def list_distributors
    distributors = Distributor.all.limit(LIMIT).select(:id, :name, :email, :phone).as_json
    distributors.each { |distributor|
      distributor["id"] = convert_id_to_uuid(distributor["id"])
    }
    render json: distributors
  end

  def search_agencies
    if params[:q].present?
      render json: search_from_db(Agency, params[:q]), status: 200
    else
      render json: [], status: 200
    end
  end

  def search_distributors
    if params[:q].present?
      render json: search_from_db(Distributor, params[:q]), status: 200
    else
      render json: [], status: 200
    end
  end

  def search_salespersons
    if params[:q].present?
      render json: search_from_db(Salesperson, params[:q]), status: 200
    else
      render json: [], status: 200
    end
  end

  private

  def search_from_db(model, name_query)
    substring_search_query = "%#{name_query}%"
    model.where("name like :query", query: substring_search_query).select(:id, :name, :phone, :email).as_json.each { |record|
      record["id"] = convert_id_to_uuid(record["id"])
    }
  end

end
