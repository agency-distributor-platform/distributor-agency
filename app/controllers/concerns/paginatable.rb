module Paginatable
  extend ActiveSupport::Concern
  included do
    def paginate(scope)
      if params[:page].present?
        page = params[:page]
        per_page = params[:per_page]
        per_page ||= 20
        total_items = scope.count
        paginated_scope = scope.paginate(page: page, per_page: per_page)
        total_pages = (total_items.to_f / per_page.to_i).ceil

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

    def non_query_paginate(data)
      #1-based indexing for page, so converting it to 0-based indexing
      page = params[:page].to_i
      per_page = params[:per_page].to_i
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
