class ItemMapping < ApplicationRecord
  self.table_name = "item_mapping_records"
  belongs_to :agency
  belongs_to :distributor, optional: true
  belongs_to :item, polymorphic: true
  has_many :transactions
  belongs_to :status
end
