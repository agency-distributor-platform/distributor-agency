class Distributor < EmployerRecord
  belongs_to :agency, optional: true
  has_many :users, as: :employer
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
