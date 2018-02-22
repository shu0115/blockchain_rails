class TradeTransaction < ApplicationRecord
  belongs_to :blockchain, optional: true
  belongs_to :block
  has_many   :transaction_outputs

  COMMON_BALANCE = 10_000.0

  class << self
    def generate_unique_key
      Digest::SHA256.hexdigest(SecureRandom.uuid)
    end
  end
end
