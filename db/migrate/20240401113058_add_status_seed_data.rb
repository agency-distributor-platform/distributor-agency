class AddStatusSeedData < ActiveRecord::Migration[7.0]
  def change
    Status.create!(
      [
        {
          name: "Added"
        },
        {
          name: "Not available"
        },
        {
          name: "Available"
        },
        {
          name: "Sold"
        },
        {
          name: "Booked"
        },
        {
          name: "Sold with due amount"
        }
      ]
    )
  end
end
