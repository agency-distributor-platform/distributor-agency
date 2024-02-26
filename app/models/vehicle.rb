class Vehicle < ApplicationRecord
  belongs_to :vehicle_model, class_name: "vehicle_model", foreign_key: "vehicle_model_id"
  has_many :item_mappings, as: :item
end
