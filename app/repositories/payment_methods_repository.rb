class PaymentMethodsRepository < Finances::Repositories::PaymentMethods
  def list_all
    PaymentMethod.all.map do |payment_method|
      if payment_method.type == 'CreditAccount'
        CREDIT_ACCOUNT_ENTITY.new(payment_method.attributes)
      else
        DEBIT_ACCOUNT_ENTITY.new(payment_method.attributes)
      end
    end
  end
end
