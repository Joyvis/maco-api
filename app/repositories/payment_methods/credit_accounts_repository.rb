module PaymentMethods
  class CreditAccountsRepository < Finances::Repositories::CreditAccountPaymentMethods
    def create(params)
      credit_account = CreditAccount.create_transaction!(params)

      ENTITY.new(credit_account.attributes)
    rescue ActiveRecord::RecordInvalid => e
      raise Finances::Repositories::CreditAccountPaymentMethods::InvalidParamsError,
        e.full_message
    end

    def find_by_id(uuid)
      ENTITY.new(CreditAccount.find(uuid).attributes)
    rescue ActiveRecord::RecordNotFound => e
      raise Finances::Repositories::CreditAccountPaymentMethods::NotFoundError
    end
  end
end
