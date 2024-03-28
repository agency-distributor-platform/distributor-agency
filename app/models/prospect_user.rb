class ProspectUser < ApplicationRecord
  belongs_to :vehicle_model
  belongs_to :refer_persona, polymorphic: true
end
