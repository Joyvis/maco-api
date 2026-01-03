module Api::V0
  # TODO: break this controller into separate controllers for expenses and incomes
  class TransactionsController < ApplicationController
    def index
      transactions = Transaction.all
      render json: transactions
    end

    def create
      transaction = klass_model.new(transaction_params)

      if transaction.payment_method.type == "CreditAccount"
        transaction.invoice_id = setup_invoice(transaction).id
      end

      transaction.save!

      render json: transaction, status: :created
    end

    def update
      transaction = Transaction.find(params[:id])
      transaction.update!(transaction_params)
      render json: transaction
    end

    def destroy
      # TODO: it should work for both expenses and incomes
      transaction = Transaction.find(params[:id])
      transaction.destroy!
      head :no_content
    end

    # TODO: rename to summary
    def monthly_summary
      transactions = Transaction.not_invoices
      transactions = transactions.ransack(params[:q])

      render json: {
        total: calculate_total,
        pending: calculate_pending,
        transactions: serialized_resources(transactions.result)
      }, status: :ok
    end

    private

    def setup_invoice(transaction)
      invoice = Invoice.find_by(
        description: transaction.payment_method.name + " Invoice",
        due_date: calculate_next_due_date(transaction.payment_method),
        payment_method_id: transaction.payment_method_id,
        paid_at: nil
      )

      return invoice if invoice

      Invoice.create(
        description: transaction.payment_method.name + " Invoice",
        due_date: calculate_next_due_date(transaction.payment_method),
        payment_method_id: transaction.payment_method_id,
        amount: transaction.amount
      )
    end

    def calculate_next_due_date(payment_method)
      next_month = Date.today
      next_month = next_month.next_month if next_month.day > payment_method.due_day

      next_month = next_month.beginning_of_month
      next_month + (payment_method.due_day - 1).days
    end

    def serialized_resources(resources)
      ActiveModelSerializers::SerializableResource.new(resources)
    end

    def calculate_total
      @calculate_total = Income.sum(:amount)
      @calculate_total -= Expense.paid.where(invoice_id: nil).sum(:amount)
      @calculate_total -= Invoice.paid.sum(:amount)
    end

    def calculate_pending
      @calculate_pending = Expense.not_paid.where(invoice_id: nil).sum(:amount)
      @calculate_pending += Invoice.not_paid.sum(:amount)
    end

    def klass_model
      params[:transaction][:type].downcase == "expense" ? Expense : Income
    end

    def transaction_params
      params
        .require(:transaction)
        .permit(
          :amount, :description, :category_id, :due_date, :payment_method_id, :paid_at
        )
    end
  end
end
