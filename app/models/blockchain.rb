class Blockchain < ApplicationRecord
  has_many :blocks
  has_many :trade_transactions
  has_many :transaction_outputs
end
