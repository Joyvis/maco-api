module Finances
  module Entities
    class PaymentMethod
      attr_accessor :id, :name, :balance

      def initialize(attributes = {})
        attributes.each do |key, value|
          instance_variable_set("@#{key}", value)
        end
      end
    end
  end
end
