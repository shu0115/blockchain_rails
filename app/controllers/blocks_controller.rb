class BlocksController < ApplicationController
  def index
    @blockchain = Blockchain.find_by(unique_key: Blockchain::UNIQUE_KEY)
    # @blocks     = Block.where(blockchain_id: @blockchain.id).order(generate_at: :desc).includes(trade_transactions: :transaction_outputs).all
    @blocks     = Block.order(id: :desc).includes(trade_transactions: :transaction_outputs).all
  end

  def confirmation
    Block.confirmation_block

    redirect_to blocks_path and return
  end

  def list_sync
    Block.list_sync

    redirect_to blocks_path and return
  end

  def list_api
    block_array = []
    blocks = Block.includes(:trade_transactions).all

    blocks.each do |block|
      block_array << block.attributes.merge(transactions: block.trade_transactions, transaction_outputs: block.transaction_outputs)
    end

    render json: { blocks: block_array, confirmations: Confirmation.all } and return
  end
end
