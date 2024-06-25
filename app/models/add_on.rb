class AddOn < ApplicationRecord
  belongs_to :item_status, class_name: "ItemStatus", foreign_key: "item_mapping_record_id"
  after_create :update_expense
  after_update :update_expense
  after_destroy :update_expense

  private

  def update_expense
    expenses = 0
    AddOn.where(item_status: ).each { |record|
      expenses = expenses + record.amount
    }
    item_status.expenses = expenses
    item_status.save!
  end
end
