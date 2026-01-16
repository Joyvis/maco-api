module Finances
  module Repositories
    class TransactionCategories
      class NotImplementedError < StandardError; end
      class NotFoundError < StandardError; end

      ENTITY = Entities::TransactionCategory

      def find_by_id(uuid)
        raise NotImplementedError, "find_by_id method must be implement"
      end
    end
  end
end
