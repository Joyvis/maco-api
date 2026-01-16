module Finances
  module Validators
    class Base
      class ValidationError < StandardError
        attr_reader :errors

        def initialize(errors)
          @errors = errors
          super(errors.to_json)
        end
      end

      def validate!(params)
        errors = validate(params)
        raise ValidationError.new(errors) if errors.any?
      end

      def validate(params)
        raise NotImplementedError
      end
    end
  end
end


