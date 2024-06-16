class Distributor < EmployerRecord
  belongs_to :agency, optional: true
  has_many :users, as: :employer
  has_many :prospect_users, as: :refer_persona
  has_many :item_statuses
  has_many :buyers, through: :item_statuses
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
