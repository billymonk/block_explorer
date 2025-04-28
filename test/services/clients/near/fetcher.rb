require "test_helper"
require "net/http"
require "json"

class Clients::Near::FetcherTest < ActiveSupport::TestCase
  NEAR_TRANSACTION = [
    {
      hash: "6RtU9UkAQaJBVMrgvtDiARxzbhx1vKrwoTv4aZRxxgt7",
      time: "2021-01-11T10:20:04.132926-06:00",
      height: 27326763,
      block_hash: "FrWmh1BtBc8yvAZPJrJ97nVth6eryukbLANyFQ3TuQai",
      sender: "86e6ebcc723106eee951c344825b91a80b46f42ff8b1f4bd366f2ac72fab99d1",
      receiver: "d73888a2619c7761735f23c798536145dfa87f9306b5f21275eb4b1a7ba971b9",
      gas_burnt: "424555062500",
      actions_count: 1,
      actions: [
        {
          type: "Transfer",
          data: { deposit: "716669915088987500000000000" }
        }.with_indifferent_access
      ],
      success: true
    }.with_indifferent_access
  ]

  def setup
    @fetcher = Clients::Near::Fetcher.new
  end

  def test_call_creates_new_near_transaction
    def @fetcher.fetch_near_transactions
      NEAR_TRANSACTION
    end

    assert_difference "NearTransaction.count", 1 do
      @fetcher.call
    end
  end

  def test_build_actions_creates_actions
    near_transaction = NearTransaction.create!(external_hash: "hash", external_sender: "sender", external_receiver: "receiver")

    assert_difference "near_transaction.actions.count", 1 do
      @fetcher.send(:build_actions, near_transaction, NEAR_TRANSACTION.first[:actions])
    end
  end
end
