module Paginatable
  extend ActiveSupport::Concern
  included do
    def paginate(scope)
      if params[:page].present?
        total_items = scope.count
        paginated_scope = scope.paginate(page: page, per_page: per_page)
        total_pages = (total_items.to_f / per_page).ceil

        metadata = {
          total_items: total_items,
          total_pages: total_pages,
          current_page: page,
          per_page: per_page
        }

        [paginated_scope.as_json, metadata]
      else
        [scope.as_json, {}]
      end
    end
  end 
end