class UseCase
  class RepositoryNotImplementedError < StandardError; end
  class NotDefinedInterface < StandardError; end

  def initialize(repositories)
    repositories.each do |key, klass|
      repository = self.class::REPOSITORIES[key]
      next if klass.nil?

      unless klass.is_a?(repository[:interface])
        raise RepositoryNotImplementedError, repository[:message]
      end

      instance_variable_set("@#{key}", klass)
    end
  end
end
