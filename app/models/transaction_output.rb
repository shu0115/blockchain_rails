class TransactionOutput < ApplicationRecord
  belongs_to :blockchain
  belongs_to :block
  belongs_to :trade_transaction
end
