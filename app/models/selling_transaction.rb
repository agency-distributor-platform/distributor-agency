class SellingTransaction < ApplicationRecord
  belongs_to :transaction_record, class_name: "Transaction", foreign_key: "transaction_id"
end
