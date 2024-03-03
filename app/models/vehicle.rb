class Vehicle < ApplicationRecord
  belongs_to :vehicle_model, class_name: "VehicleModel", foreign_key: "vehicle_model_id"
  has_one :item_mapping, as: :item
  validates :registration_id, presence: true, uniqueness: true
  validates :chassis_id, presence: true, uniqueness: true
  validates :engine_id, presence: true, uniqueness: true
end
