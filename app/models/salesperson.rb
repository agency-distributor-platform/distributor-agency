class Salesperson < ApplicationRecord
  self.table_name = "salespersons"
  has_many :referrals
  has_many :users, as: :employer
  has_many :item_statuses

  def is_verified?
    #will change to check from verified column, would populate it during registration and remove this function
    government_document.present? && government_document_identification.present?
  end
end
