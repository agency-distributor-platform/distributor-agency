class User < ApplicationRecord
  belongs_to :employer, polymorphic: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
