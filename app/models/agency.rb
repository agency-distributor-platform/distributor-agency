class Agency < EmployerRecord
  has_many :distributors
  has_many :item_mappings
  has_many :users, as: :employer
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def self.generate_uuid
    current_uuids = all.pluck(:uuid)
    new_uuid = nil
    while current_uuids.include?(new_uuid) || new_uuid.blank?
      o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
      new_uuid = (0...uuid_string_limit).map { o[rand(o.length)] }.join
    end
    new_uuid
  end

  private

  def self.uuid_string_limit
    50
  end

end
