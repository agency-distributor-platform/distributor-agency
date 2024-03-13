class Vehicle < ApplicationRecord
  belongs_to :vehicle_model, class_name: "VehicleModel", foreign_key: "vehicle_model_id", optional: true

  has_one :item_mapping, as: :item
  has_one :agency, through: :item_mapping
  has_one :distributor, through: :item_mapping
  has_one :buyer, through: :item_mapping

  validates :registration_id, presence: true, uniqueness: true
  validates :chassis_id, presence: true, uniqueness: true
  validates :engine_id, presence: true, uniqueness: true

  def distributor_id
    distributor.id rescue nil
  end

  def agency_id
    agency.id
  end

  def buyer_id
    buyer.id
  end

end
