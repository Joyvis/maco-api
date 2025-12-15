class Api::V0::PaymentMethods::InvoicesController < ApplicationController
  def create
    # find all transactions with invoice_id nil and associated to this payment method
    # create invoice transaction
    # associate invoice to all transactions
    ActiveRecord::Base.transaction do
      expenses = payment_method.transactions.where(type: 'Expense', invoice_id: nil)
      invoice = create_invoice
      expenses = expenses.where.not(id: invoice.id)
      raise ActiveRecord::RecordInvalid.new(invoice) if expenses.sum(:amount) != invoice.amount

      expenses.update!(invoice_id: invoice.id)
      invoice.reload

      render json: invoice,
        status: :created, serializer: ::ExpenseSerializer
    end
  end

  private

  def create_invoice
    attrs = invoice_params.merge(payment_method_id: payment_method.id)
    attrs[:description] = "#{payment_method.name} Invoice"
    attrs[:is_invoice] = true
    Expense.create!(attrs)
  end

  def payment_method
    @payment_method ||= CreditAccount.find(params[:payment_method_id])
  end

  def invoice_params
    params.require(:payment_method_invoice).permit(:due_date, :amount)
  end
end
