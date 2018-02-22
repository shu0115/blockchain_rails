class Block < ApplicationRecord
  belongs_to :blockchain
  has_many   :trade_transactions
  has_many   :transaction_outputs

  DIFFICULTY = '0'

  class << self
    def proof_of_work(block: nil)
      nonce                 = 0
      proof_of_work_history = []

      loop do
        sha256_hash = Block.calc_hash_with_nonce(block: block, nonce: nonce)

        proof_of_work_history << sha256_hash

        if sha256_hash.start_with?(Block::DIFFICULTY)
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

    # bundle exec rails runner "Block.list_sync"
    def list_sync
      nodes = Node.all

      nodes.each do |node|
        begin
          response = RestClient.get("#{node.end_point}/blocks/list_api")
          response_body = JSON.parse(response.body).deep_symbolize_keys

          response_body[:blocks].each do |block|
            Block.create_with(
              blockchain_id:         block[:blockchain_id],
              index:                 block[:index],
              generate_at:           block[:generate_at],
              nonce:                 block[:nonce],
              previous_hash:         block[:previous_hash],
              proof_of_work_history: block[:proof_of_work_history],
              confirmation_count:    block[:confirmation_count],
            ).find_or_create_by!(
              hash_key: block[:hash_key],
            )
          end
        rescue => exception
          puts "[ ---------- exception ---------- ]"; exception.message.tapp;
        end
      end
    end

    # bundle exec rails runner "Block.confirmation_block"
    def confirmation_block
      keys       = Confirmation.pluck(:block_hash_key)
      block_keys = Block.pluck(:hash_key)

      if keys.blank?
        blocks = Block.all
      else
        blocks = Block.where('hash_key NOT IN(?)', keys.compact)
      end

      blocks.each do |block|
        if Block.calc_hash_with_nonce(block: block, nonce: block.nonce.to_i).start_with?(Block::DIFFICULTY)
          Confirmation.find_or_create_by!(
            block_hash_key: block.hash_key,
            host:           Settings.http_host,
            status:         true,
          )

          block.update!(confirmation_count: Confirmation.where(block_hash_key: block.hash_key).count)
        end
      end
    end
  end
end
