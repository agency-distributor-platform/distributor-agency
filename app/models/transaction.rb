class Transaction < ApplicationRecord
  belongs_to :item_status, class_name: "ItemStatus", foreign_key: "item_mapping_record_id"
  has_one :selling_transaction
  has_one :booking_transaction
  alias_attribute :item_status_id, :item_mapping_record_id
end
