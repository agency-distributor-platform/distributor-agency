class Agency < ApplicationRecord
  has_many :distributors
  has_many :item_mappings
  has_many :users, as: :employer
end
