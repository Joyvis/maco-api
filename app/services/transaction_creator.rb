class TransactionCreator
  class InvalidParams < StandardError; end

  attr_reader :repo

  def initialize(repo:)
    @repo = repo
  end

  def call(params:)
    repo.create(params)
  rescue ActiveRecord::RecordInvalid
    # TODO: implement logs
    raise InvalidParams
  end
end
