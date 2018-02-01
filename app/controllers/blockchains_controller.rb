class BlockchainsController < ApplicationController
  permits :name

  def index
    @blockchains = Blockchain.all
  end

  def show(id)
    @blockchain = Blockchain.find_by(id: id)
    @blocks = Block.where(blockchain_id: id).order(generate_at: :desc).all
  end

  def new
    @blockchain = Blockchain.new
  end

  def create(blockchain)
    @blockchain = Blockchain.new(blockchain)

    if @blockchain.save
      redirect_to @blockchain, notice: 'Blockchain was successfully created.'
    else
      render :new
    end
  end
end
