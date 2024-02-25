class Distributor < ApplicationRecord
  belongs_to :agency
  has_many :users, as: :employer
end
