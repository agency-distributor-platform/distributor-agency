module Utils 
  module Pagination
    def paginate(scope, page, per_page)
      if page.present?
        scope.all.paginate(page: page, per_page: per_page)
      else
        scope.all
      end
    end 
  end 
end 