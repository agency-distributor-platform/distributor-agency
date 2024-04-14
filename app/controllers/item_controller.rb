class ItemController < AuthenticationController

  def statuses
    if session_user_service.is_distributor? || session_user_service.is_agency?
      render json: Status.all.as_json, status: 200
    else
      render json: {
        error: "User is forbidden"
      }, status: 403
    end
  end

  def add_or_edit_distributor_share
    if verify_agency_obj
      "ItemService::#{params[:item_type].capitalize}Obj".constantize.new({id: params[:item_id]}).update_share(:distributor_share, params[:share])
      render json:{}, status: 204
    else
      render json: {
        error: "User is forbidden"
      }, status: 403
    end
  end

  def add_or_edit_salesperson_share
    if verify_agency_obj
      "ItemService::#{params[:item_type].capitalize}Obj".constantize.new({id: params[:item_id]}).update_share(:salesperson_share, params[:share])
      render json:{}, status: 204
    else
      render json: {
        error: "User is forbidden"
      }, status: 403
    end
  end

  private

  def verify_agency_obj
    employer.present? && session_user_service.is_agency?
  end


end
