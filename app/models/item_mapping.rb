class ItemMapping < ApplicationRecord
  self.table_name = "item_selling_records"
  belongs_to :agency
  belongs_to :distributor, optional: true
  belongs_to :buyer, optional:  true
  belongs_to :item, polymorphic: true
end
