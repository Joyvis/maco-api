class Api::V0::PaymentMethodsController < ApplicationController
  def index
    render json: PaymentMethod.all
  end

  def create
    # persist payment method
    attributes = payment_method_params
    attributes[:balance] = params[:payment_method][:initial_balance]
    payment_method = payment_method_klass.create!(attributes)

    if params[:payment_method][:initial_balance] &&
        !params[:payment_method][:initial_balance].to_f.zero?
      Income.create!(
        amount: params[:payment_method][:initial_balance],
        due_date: Date.current,
        description: "Initial balance",
        payment_method_id: payment_method.id
      )
    end

    render json: payment_method, status: :created
  end

  def build_transaction
    return Expense if params[:payment_method][:type] == "CreditAccount"
  end

  def update
    payment_method = DebitAccount.find(params[:id])
    payment_method.update!(payment_method_params)
    render json: payment_method
  end

  def destroy
    payment_method = DebitAccount.find(params[:id])
    payment_method.destroy!
    head :no_content
  end

  private

  def payment_method_klass
    methods = {
      "DebitAccount" => DebitAccount,
      "CreditAccount" => CreditAccount
    }
    methods.fetch(params[:payment_method][:type])
  end

  def payment_method_params
    params.require(:payment_method).permit(:name, :due_day)
  end
end
