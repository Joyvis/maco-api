module Transactions
  class InvalidInvoiceError < StandardError; end
  class InvoiceNotFoundError < StandardError; end

  class InvoicesRepository < Finances::Repositories::InvoiceTransactions
    def create(params)
      income = Income.create_transaction!(params)

      ENTITY.new(income.attributes)
    rescue ActiveRecord::RecordInvalid => e
      raise InvalidInvoiceError, e.full_message
    end

    def find_by(params)
      ENTITY.new(Invoice.find_by!(params).attributes)
    rescue ActiveRecord::RecordNotFound => e
      raise InvoiceNotFoundError
    end
  end
end
