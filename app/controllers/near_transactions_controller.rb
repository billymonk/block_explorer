class NearTransactionsController < ApplicationController
  def index
    @near_transactions = NearTransaction
      .includes(:actions)
      .joins(:actions)
      .where(actions: { action_type: "Transfer" })
      .distinct
  end

  def fetch
    Clients::Near::Fetcher.call
    redirect_to root_path, notice: "Near Transactions have been fetched"
  end
end
