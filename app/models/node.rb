class Node < ApplicationRecord

  class << self
    def list_sync
      nodes = Node.all

      nodes.each do |node|
        begin
          response = RestClient.get("#{node.end_point}#{node.list_path}")
          response_body = JSON.parse(response.body).deep_symbolize_keys

          response_body[:nodes].each do |node|
            Node.create_with(
              name:      node[:name],
              list_path: node[:list_path]
            ).find_or_create_by!(
              end_point: node[:end_point],
            )
          end
        rescue => exception
          puts "[ ---------- exception ---------- ]"; exception.message.tapp;
        end
      end
    end
  end
end
