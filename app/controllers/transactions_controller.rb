class TransactionsController < ApplicationController
  def create
    render json: {}, status: :created
  end
end
