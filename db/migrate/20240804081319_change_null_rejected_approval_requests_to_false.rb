class ChangeNullRejectedApprovalRequestsToFalse < ActiveRecord::Migration[7.0]
  def change
    SalespersonAgencyLinking.where(rejected: nil).update_all(rejected: false)
  end
end
