class TransactionCategoriesRepository < Finances::Repositories::TransactionCategories
  class InvalidTransactionError < StandardError; end

  def find_by_id(uuid)
    category = Category.find(uuid)
    ENTITY.new(category.attributes)
  end
end
