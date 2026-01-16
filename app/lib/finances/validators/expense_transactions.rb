module Finances
  module Validators
    class ExpenseTransactions < Base
      attr_reader :payment_method_entity, :transaction_category_entity

      def initialize(payment_method_entity:, transaction_category_entity:)
        @payment_method_entity = payment_method_entity
        @transaction_category_entity = transaction_category_entity
      end

      def validate(params)
        errors = []

        # Presence/type validations
        errors << { amount: "is required" } if params[:amount].nil?
        errors << { amount: "must be positive" } if params[:amount]&.negative?
        errors << { description: "is required" } if params[:description].to_s.empty?
        errors << { due_date: "is required" } if !params[:due_date] || !params[:due_date].to_date

        # Business rules using repos
        payment_method_id = params[:payment_method_id]
        unless payment_method_id || payment_method_id == payment_method_entity.id
          errors << { payment_method_id: "Payment Method must exist" }
        end

        transaction_category_id = params[:category_id]
        unless transaction_category_id || transaction_category_id == transaction_category_entity.id
          errors << { transact_category_id: "Category must exist" }
        end

        errors
      end
    end
  end
end
