class TransactionsController < ApplicationController
  permits :hash_key, :sender_address, :input_amount

  def generate(blockchain_id, sender_address, receiver_address, output_amount)
    ActiveRecord::Base.transaction do
      # ブロック作成
      block = Block.new
      block.blockchain_id = blockchain_id
      block.index         = Block.where(blockchain_id: blockchain_id).maximum(:index).to_i + 1
      block.previous_hash = Block.where(blockchain_id: blockchain_id).order(index: :desc).first&.hash_key
      block.generate_at   = Time.current
      block.save!

      # トランザクション作成
      transaction = TradeTransaction.new
      transaction.blockchain_id  = blockchain_id
      transaction.block_id       = block.id
      transaction.hash_key       = 'TODO: hash_key'
      transaction.sender_address = sender_address
      transaction.input_amount   = TradeTransaction::COMMON_BALANCE
      transaction.generate_at    = Time.current
      transaction.save!

      # 送信先トランザクション作成
      transaction_output = TransactionOutput.new
      transaction_output.blockchain_id        = blockchain_id
      transaction_output.block_id             = block.id
      transaction_output.trade_transaction_id = transaction.id
      transaction_output.receiver_address     = receiver_address
      transaction_output.output_amount        = output_amount
      transaction_output.generate_at          = Time.current
      transaction_output.save!

      # プルーフ・オブ・ワーク
      hash_key, nonce, proof_of_work_history = Block.proof_of_work(block: block)

      block.hash_key              = hash_key
      block.nonce                 = nonce
      block.proof_of_work_history = proof_of_work_history
      block.save!
    end

    redirect_to blockchain_path(blockchain_id), notice: '取引を追加しました。' and return
  end
end
