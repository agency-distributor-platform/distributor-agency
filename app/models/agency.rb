class Agency < EmployerRecord
  has_many :distributors
  has_many :item_mappings
  has_many :users, as: :employer
  has_many :prospect_users, as: :refer_persona
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
