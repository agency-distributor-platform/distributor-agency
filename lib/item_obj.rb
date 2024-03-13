require_relative "./buyer_obj.rb"

module BusinessLogic
  class ItemObj

    attr_accessor :extra_data

    def initialize(record)
      @extra_data = {}
      @record = record[:id].present? ? model.find_by(id: record[:id]) : model.new(clean_record(record))
    end

    def create_or_update(data, agency_id)
      record.agency_id = agency_id
      model.transaction {
        distributor_id = data.delete(:distributor_id) || extra_data[:distributor_id]
        distributor_id = nil if distributor_id.present? && invalid_distributor?(agency_id, distributor_id)
        if record.persisted?
          record.update!(data)
        else
          record.save!
        end
        if record.item_mapping.blank?
          write_hash = {item_type: model.to_s, agency_id: , item_id: record.id}
          write_hash.merge!({distributor_id: }) if distributor_id.present?
          ItemMapping.create!(write_hash)
        else
          item_mapping = record.item_mapping
          write_hash = {item_type: model.to_s, agency_id: , item_id: record.id}
          write_hash.merge!({distributor_id: }) if distributor_id.present?
          item_mapping.update(write_hash)
        end
      }
    end

    def json_obj
      record.as_json.merge!({ item_mapping_details: ItemMapping.find_by(item_id: record.id, item_type: model.to_s).as_json })
    end

    def sell(selling_transaction_details)
      if record.persisted?
        persona_id = selling_transaction_details[:persona_id]
        raise "Wrong persona as there is no distributor" if record.distributor_id.blank? && persona_id == Persona.distributor_id
        persona_id = record.distributor_id.present? ? Persona.distributor_id : Persona.agency_id if persona_id.blank?
        model.transaction {
          record.selling_price = selling_transaction_details[:item_selling_price]
          record.save!
          record.item_mapping.update(seller_persona_id: persona_id)
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
        seller_persona_id = item_mapping.seller_persona_id
        item_details = item_mapping.item.as_json.deep_symbolize_keys
        next if item_details[:selling_price].blank?
        if distributor_details.present? && Persona.distributor_id == seller_persona_id
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

    def extra_columns
      []
    end

    def model
    end

    def clean_record(record_hash)
      extra_columns.each { |column|
        @extra_data[column] = record_hash.delete(column)
      }
      record_hash
    end

    def invalid_distributor?(agency_id, distributor_id)
      Distributor.find_by(id: distributor_id).agency_id != agency_id rescue true
    end

    def add_buyer_to_item_mapping(buyer_obj)
      item_mapping = record.item_mapping
      item_mapping.buyer_id = buyer_obj.record_id
      item_mapping.save!
    end
  end
end
