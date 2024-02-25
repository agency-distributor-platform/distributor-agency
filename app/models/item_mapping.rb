class ItemMapping < ApplicationRecord
  self.table_name = "item_selling_records"
  belongs_to :agency
  belongs_to :distributor
  belongs_to :buyer
  belongs_to :item, polymorphic: true
end
