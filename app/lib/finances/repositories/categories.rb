module Finances
  module Repositories
    class Categories
      class NotImplementedError < StandardError; end

      ENTITY = Entities::Category

      def find_by_id(uuid)
        raise NotImplementedError, "find_by_id method must be implement"
      end
    end
  end
end
