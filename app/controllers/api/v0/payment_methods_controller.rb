class Api::V0::PaymentMethodsController < ApplicationController
  def create
    render json: {}, status: :created
  end
end
