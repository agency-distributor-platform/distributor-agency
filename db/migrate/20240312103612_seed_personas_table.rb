class SeedPersonasTable < ActiveRecord::Migration[7.0]
  def up
    Persona.create!({
      id: 1,
      persona_name: "Agency"
    }) if Persona.find_by(persona_name: "Agency").blank?

    Persona.create!({
      id: 2,
      persona_name: "Distributor"
    }) if Persona.find_by(persona_name: "Distributor").blank?
  end

  def down
    Persona.find_by(persona_name: "Agency").destroy rescue nil

    Persona.find_by(persona_name: "Distributor").destroy rescue nil
  end
end
