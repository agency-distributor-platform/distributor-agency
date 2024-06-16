module Utils 
  module Pagination
    def paginate(scope, page, per_page)
      if page.present?
        total_items = scope.all.count 
        paginated_scope = scope.all.paginate(page: page, per_page: per_page)
        total_pages = (total_items.to_f / per_page.to_i).ceil

        metadata = {
          total_items: total_items,
          total_pages: total_pages,
          current_page: page,
          per_page: per_page
        }
        p metadata
        [paginated_scope, metadata]
      else
        [scope.all, {}]
      end
    end 
  end 
end 