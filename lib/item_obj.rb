require_relative "./buyer_obj.rb"

module BusinessLogic
  class ItemObj
    def initialize(record)
      @record = record[:id].present? ? model.find_by(id: record[:id]) : model.new(record)
    end

    def create_or_update(data, agency_id)
      record.agency_id = agency_id
      model.transaction {
        distributor_id = data.delete(:distributor_id)
        if record.persisted?
          record.update!(data)
        else
          record.save!
        end
        if record.item_mapping.blank?
          ItemMapping.create!({item_type: model.to_s, agency_id: , distributor_id: , item_id: record.id})
        else
          item_mapping = record.item_mapping
          item_mapping.update({item_type: model.to_s, agency_id: , distributor_id: , item_id: record.id})
        end
      }
    end

    def sell(selling_transaction_details)
      if record.persisted?
        model.transaction {
          record.selling_price = selling_transaction_details[:item_selling_price]
          record.save!
          buyer_obj = BusinessLogic::BuyerObj.new(selling_transaction_details[:buyer_details])
          buyer_obj.create_or_update(selling_transaction_details[:buyer_details])
          add_buyer_to_item_mapping(buyer_obj)
        }
      else
        raise "Incorrect item id"
      end
    end

    def self.get_sold_items(item_mappings, limit, offset)
      item_distributor_details = {
        distributor_sold_items: [],
        agency_sold_items: []
      }
      distributor_details_hash = {}
      item_mappings.each { |item_mapping|
        distributor_details = item_mapping.distributor.as_json.deep_symbolize_keys rescue nil
        item_details = item_mapping.item.as_json.deep_symbolize_keys
        next if item_details[:selling_price].blank?
        if distributor_details.present?
          distributor_id = distributor_details.delete(:id)
          distributor_details_hash[distributor_id] = distributor_details.merge!({item_details: []}) if !distributor_details_hash.keys.include?(distributor_id)
          distributor_details_hash[distributor_id][:item_details].push(item_details)
        else
          item_distributor_details[:agency_sold_items].push(item_details)
        end
      }
      distributor_details_hash.each { |key, value|
        item_distributor_details[:distributor_sold_items].push({
          id: key
        }.merge!(value))
      }
      item_distributor_details
    end

    private

    def model
    end

    def add_buyer_to_item_mapping(buyer_obj)
      item_mapping = record.item_mapping
      item_mapping.buyer_id = buyer_obj.record_id
      item_mapping.save!
    end
  end
end
