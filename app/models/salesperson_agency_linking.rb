class SalespersonAgencyLinking < ApplicationRecord
  belongs_to :salesperson
  belongs_to :agency
end
