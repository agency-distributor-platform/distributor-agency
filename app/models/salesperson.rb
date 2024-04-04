class Salesperson < ApplicationRecord
  self.table_name = "salespersons"
  has_many :users, as: :employer
  has_many :item_mapping_records
end
