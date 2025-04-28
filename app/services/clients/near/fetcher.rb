require "net/http"
require "json"

module Clients
  module Near
    class Fetcher
      API_URL = URI("#{Settings::API_URL}#{Rails.application.credentials.near[:api_key]}")

      class << self
        def call
          new.call
        end
      end

      def call
        fetch_near_transactions.each do |near_transaction_data|
          process_near_transaction(near_transaction_data)
        end
      end

      private

      def fetch_near_transactions
        near_transactions = Net::HTTP.get(API_URL)
        JSON.parse(near_transactions)
      rescue
        []
      end

      def process_near_transaction(near_transaction_data)
        new_or_created_near_transaction = NearTransaction.find_or_create_by(external_hash: near_transaction_data["hash"]) do |near_transaction|
          near_transaction.external_time = near_transaction_data["time"]
          near_transaction.external_height = near_transaction_data["height"]
          near_transaction.external_block_hash = near_transaction_data["block_hash"]
          near_transaction.external_sender = near_transaction_data["sender"]
          near_transaction.external_receiver = near_transaction_data["receiver"]
          near_transaction.external_gas_burnt = near_transaction_data["gas_burnt"]
          near_transaction.external_actions_count = near_transaction_data["actions_count"]
          near_transaction.external_success = near_transaction_data["success"]
        end

        return unless new_or_created_near_transaction.persisted?

        build_actions(new_or_created_near_transaction, near_transaction_data["actions"])
      end

      def build_actions(near_transaction, actions)
        near_transaction.actions.destroy_all

        Array(actions).each do |action_data|
          near_transaction.actions.create!(
            action_type: action_data["type"],
            data: action_data["data"]
          )
        end
      end
    end
  end
end
