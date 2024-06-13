module Paginatable
  extend ActiveSupport::Concern
  included do
    def paginate(scope)
      if params[:page].present?
        scope.paginate(page: params[:page], per_page: params[:per_page]).as_json
      else
        scope.as_json
      end
    end
  end 
end