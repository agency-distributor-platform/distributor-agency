class Salesperson < ApplicationRecord
  self.table_name = "salespersons"
  has_many :referrals
  has_many :users, as: :employer
  has_many :item_statuses
  has_many :salesperson_agency_linkings
  has_many :linked_agencies, through: :salesperson_agency_linkings, source: :agency

  def is_verified?
    #will change to check from verified column, would populate it during registration and remove this function
    government_document.present? && government_document_identification.present?
  end
end
