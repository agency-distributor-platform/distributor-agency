class Salesperson < ApplicationRecord
  self.table_name = "salespersons"
  has_many :users, as: :employer
end
