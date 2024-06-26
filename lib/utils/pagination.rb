module Utils
  module Pagination
    def paginate(scope, page, per_page)
      if page.present?
        per_page ||= 20
        paginated_scope = scope.all.paginate(page: page, per_page: per_page)

        [paginated_scope, metadata(scope.all.count, page, per_page)]
      else
        [scope.all, {}]
      end
    end

    def non_query_paginate(data, page, per_page)
      #1-based indexing for page, so converting it to 0-based indexing
      start_index = (page - 1) * per_page
      [data[start_index, per_page] || [], metadata(data.length, page, per_page)]
    end

    def metadata(scope_count, page, per_page)
      total_items = scope_count
      total_pages = (total_items.to_f / per_page.to_i).ceil

      {
        total_items: total_items,
        total_pages: total_pages,
        current_page: page,
        per_page: per_page
      }
    end
  end
end
