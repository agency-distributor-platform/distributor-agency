class Agency < EmployerRecord
  has_many :distributors
  has_many :item_statuses
  has_many :users, as: :employer
  has_many :prospect_users, as: :refer_persona
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  has_many :inquiries
  has_many :buyers, through: :item_statuses

  def folder_name
    "Agency_#{agency_record.name}_#{agency_record.id}"
  end
end
