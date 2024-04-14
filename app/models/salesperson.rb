class Salesperson < ApplicationRecord
  self.table_name = "salespersons"
  has_many :users, as: :employer
  has_many :item_statuses
end
