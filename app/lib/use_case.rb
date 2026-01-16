class UseCase
  class RepositoryNotImplementedError < StandardError; end
  class NotDefinedInterface < StandardError; end

  attr_accessor :validator

  def initialize(repositories:, validator: nil)
    repositories.each do |key, klass|
      repository = self.class::REPOSITORIES[key]
      next if klass.nil?

      unless repository
        raise RepositoryNotImplementedError, "REPOSITORIES not defined"
      end

      unless klass.is_a?(repository[:interface])
        raise RepositoryNotImplementedError, repository[:message]
      end

      instance_variable_set("@#{key}", klass)
    end

    @validator = validator || build_validator
  end

  def build_validator
    return if self.class == Finances::UseCases::CreateExpenseTransaction

    self.class::VALIDATOR[:class].new(**validator_args)
  end

  def validator_args
    args = {}
    self.class::VALIDATOR[:repositories].each do |repo|
      args[repo] = send(repo)
    end

    args
  end
end
