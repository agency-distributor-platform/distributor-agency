class Distributor < EmployerRecord
  belongs_to :agency, optional: true
  has_many :users, as: :employer
  has_many :item_mappings
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
