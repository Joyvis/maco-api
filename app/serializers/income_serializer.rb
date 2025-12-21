class IncomeSerializer < ActiveModel::Serializer
  attributes :id, :amount, :description, :due_date, :status, :type

  def status
    ''
  end
end
