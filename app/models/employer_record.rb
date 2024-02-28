class EmployerRecord < ApplicationRecord
  self.abstract_class = true

  def create_super_user
    User.create!({
      name: "Super Admin",
      email: ,
      phone: ,
      employer_type: itself.class.name,
      employer_id: id,
    })
  end

end
