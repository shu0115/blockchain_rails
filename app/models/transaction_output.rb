class TransactionOutput < ApplicationRecord
  belongs_to :blockchain, optional: true
  belongs_to :block
  belongs_to :trade_transaction
end
