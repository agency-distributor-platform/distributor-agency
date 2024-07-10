class PreLoginController < ApplicationController
  include Paginatable

  def list_agencies
    agencies,meta = paginate(Agency.all.select(:id, :name, :email, :phone))
    agencies.each { |agency|
      agency["id"] = convert_id_to_uuid(agency["id"])
    }

    render json: {data: agencies, pageable: meta}
  end

  def list_distributors
    distributors,meta = paginate(Distributor.all.select(:id, :name, :email, :phone))
    distributors.each { |distributor|
      distributor["id"] = convert_id_to_uuid(distributor["id"])
    }
    render json: {data: distributors, pageable: meta}
  end

  def search_agencies
      render json: search_from_db(Agency, params[:q]), status: 200
  end

  def search_distributors
      render json: search_from_db(Distributor, params[:q]), status: 200
  end

  def search_salespersons
      render json: search_from_db(Salesperson, params[:q]), status: 200
  end

  private

  def search_from_db(model, name_query)
    substring_search_query = "%#{name_query}%"
    records, meta = paginate(model.where("name like :query or email like :query", query: substring_search_query).select(:id, :name, :phone, :email))
    records.each { |record|
      record["id"] = convert_id_to_uuid(record["id"])
    }

    {data: records, pageable: meta}
  end
end
