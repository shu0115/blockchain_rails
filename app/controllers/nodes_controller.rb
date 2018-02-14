class NodesController < ApplicationController
  permits :name, :end_point, :list_path

  def index
    @nodes = Node.order(created_at: :desc)
    @node  = Node.new
  end

  def create(node)
    @node = Node.new(node)
    @node.save!

    redirect_to nodes_path, notice: 'ノードを登録しました。'
  end
end