module Utils
  class TransactionUtils
    def self.derive_transaction(transaction_type)
      "ItemService::TransactionStrategy::#{transaction_type}TransactionStrategy".constantize
    end
  end
end
