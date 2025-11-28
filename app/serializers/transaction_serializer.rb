class TransactionSerializer < ActiveModel::Serializer
  belongs_to :category

  attributes :id, :amount, :description, :due_date, :category, :type
end
