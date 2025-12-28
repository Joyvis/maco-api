module Api::V0
  # TODO: break this controller into separate controllers for expenses and incomes
  class TransactionsController < ApplicationController
    def index
      transactions = Transaction.all
      render json: transactions
    end

    def create
      transaction = klass_model.create!(transaction_params)
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
      transactions = Transaction.where(invoice_id: nil)

      if params[:month]
        transactions = transactions.where("extract(month from due_date) = ?", params[:month])
      end

      render json: {
        total: calculate_total,
        pending: calculate_pending,
        transactions: serialized_resources(transactions)
      }, status: :ok
    end

    private

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
          :amount, :description, :category_id, :due_date, :payment_method_id
        )
    end
  end
end
