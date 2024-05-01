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

  def buyer_exists?(buyer_record)
    item_statuses.pluck(:buyer_id).include?(buyer_record.id)
  end

end
