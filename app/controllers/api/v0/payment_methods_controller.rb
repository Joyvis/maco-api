class Api::V0::PaymentMethodsController < ApplicationController
  def create
    attributes = payment_method_params
    attributes[:balance] = 0
    payment_method = DebitAccount.create!(attributes)

    render json: payment_method, status: :created
  end

  private

  def payment_method_params
    params.require(:payment_method).permit(:name)
  end
end
