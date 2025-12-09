class Api::V0::PaymentMethodsController < ApplicationController
  def index
    render json: DebitAccount.all
  end

  def create
    # persist payment method
    attributes = payment_method_params
    attributes[:balance] = params[:payment_method][:initial_balance]
    payment_method = DebitAccount.create!(attributes)

    # create initial balance transaction
    Income.create!(
      amount: params[:payment_method][:initial_balance],
      due_date: Date.current,
      description: 'Initial balance',
      payment_method_id: payment_method.id
    )

    render json: payment_method, status: :created
  end

  def update
    payment_method = DebitAccount.find(params[:id])
    payment_method.update!(payment_method_params)
    render json: payment_method
  end

  private

  def payment_method_params
    params.require(:payment_method).permit(:name)
  end
end
