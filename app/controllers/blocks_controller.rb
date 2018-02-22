class BlocksController < ApplicationController
  def index
    @blockchain = Blockchain.find_by(unique_key: Blockchain::UNIQUE_KEY)
    @blocks     = Block.where(blockchain_id: @blockchain.id).order(generate_at: :desc).includes(trade_transactions: :transaction_outputs).all
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
    blocks = Block.all

    render json: { blocks: blocks } and return
  end
end
