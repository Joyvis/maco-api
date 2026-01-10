module Finances
  module Entities
    class Transaction
      attr_accessor :id, :description, :amount, :due_date,
        :paid_at, :payment_method_id

      def initialize(attributes = {})
        attributes.each do |key, value|
          instance_variable_set("@#{key}", value)
        end
      end
    end
  end
end
