module Transactions
  class IncomeCreator
    attr_reader :repository

    def initialize(repository:)
      @repository = repository
    end

    def call(params:)
      repository.create(params)
    end
  end
end
