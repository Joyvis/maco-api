class PaymentMethodsRepository < Finances::Repositories::PaymentMethods
  def list_all
    PaymentMethod.all.map { to_entity(_1) }
  end

  def find_by_id(uuid)
    to_entity PaymentMethod.find(uuid)
  end

  def to_entity(payment_method)
    return CREDIT_ACCOUNT_ENTITY.new(payment_method.attributes) if payment_method.type == "CreditAccount"

    DEBIT_ACCOUNT_ENTITY.new(payment_method.attributes)
  end
end
