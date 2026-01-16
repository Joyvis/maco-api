module Finances
  module Entities
    class TransactionCategory
      attr_accessor :id, :name

      def initialize(attributes = {})
        attributes.each do |key, value|
          instance_variable_set("@#{key}", value)
        end
      end
    end
  end
end
