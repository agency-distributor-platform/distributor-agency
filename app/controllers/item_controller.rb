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


end
