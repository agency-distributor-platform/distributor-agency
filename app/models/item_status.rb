class ItemStatus < ApplicationRecord
  self.table_name = "item_mapping_records"
  belongs_to :agency
  belongs_to :distributor, optional: true
  belongs_to :salesperson, optional: true
  belongs_to :buyer, optional: true
  belongs_to :item, polymorphic: true
  has_many :transactions, class_name: "Transaction", foreign_key: :item_mapping_record_id
  has_many :selling_transactions, through: :transactions
  has_many :booking_transactions, through: :transactions
  belongs_to :status
end
