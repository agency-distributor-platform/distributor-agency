class Distributor < EmployerRecord
  belongs_to :agency, optional: true
  has_many :users, as: :employer
end
