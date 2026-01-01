class PaymentMethodSerializer < ActiveModel::Serializer
  attributes :id, :name, :balance, :type
end
