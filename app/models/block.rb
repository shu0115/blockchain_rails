class Block < ApplicationRecord
  belongs_to :blockchain
  has_many   :trade_transactions
  has_many   :transaction_outputs

  class << self
    def proof_of_work(block: nil, difficulty: '0')
      nonce                 = 0
      proof_of_work_history = []

      loop do
        sha256_hash = Block.calc_hash_with_nonce(block: block, nonce: nonce)

        proof_of_work_history << sha256_hash

        if sha256_hash.start_with?(difficulty)
          return sha256_hash, nonce, proof_of_work_history
        else
          nonce += 1
        end
      end
    end

    def calc_hash_with_nonce(block: nil, nonce: 0)
      Digest::SHA256.hexdigest({
        timestamp:     block.generate_at.to_i,
        transactions:  block.trade_transactions.to_json,
        previous_hash: block.previous_hash,
        nonce:         nonce
      }.to_json)
    end
  end
end
