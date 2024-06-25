class AddUniqueConstraintToItemMappingRecords < ActiveRecord::Migration[7.0]
  def change
    add_index :item_mapping_records, [:item_type, :item_id], unique: true, name: 'index_item_mapping_records_on_item_type_and_item_id'
  end
end