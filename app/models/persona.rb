class Persona < ApplicationRecord

  def self.distributor_id
    find_by(persona_name: "Distributor").id rescue nil
  end

  def self.agency_id
    find_by(persona_name: "Agency").id rescue nil
  end

end
