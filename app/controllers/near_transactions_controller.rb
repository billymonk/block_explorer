class NearTransactionsController < ApplicationController
  def index
    @near_transactions = NearTransaction
      .joins(:actions)
      .where(actions: { action_type: "Transfer" })
      .distinct
  end
end
