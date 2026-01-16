class UseCase
  class RepositoryNotImplementedError < StandardError; end
  class MissingRepositoryError < StandardError; end
  class NotDefinedInterface < StandardError; end

  attr_accessor :validator

  def initialize(repositories:, validator: nil)
    unless (repositories.keys - self.class::REPOSITORIES.keys).empty?
      raise MissingRepositoryError
    end

    repositories.each do |key, klass|
      repository = self.class::REPOSITORIES[key]

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
