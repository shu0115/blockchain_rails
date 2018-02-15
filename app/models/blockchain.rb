class Blockchain < ApplicationRecord
  has_many :blocks
  has_many :trade_transactions
  has_many :transaction_outputs

  UNIQUE_KEY = 'e4f02b9490ea0a8583a2923292800745b3111c68268c97aa6b4058504dc53782'
end
