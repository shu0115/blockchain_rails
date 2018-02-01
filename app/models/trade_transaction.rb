class TradeTransaction < ApplicationRecord
  belongs_to :blockchain
  belongs_to :block
  has_many   :transaction_outputs

  COMMON_BALANCE = 10_000
end
