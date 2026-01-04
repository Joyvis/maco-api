require 'rails_helper'

RSpec.describe TransactionCreator do
  subject(:transaction) { described_class.new }

  it 'returns an instance of TransactionCreator' do
    expect(transaction).to be_a(TransactionCreator)
  end
end
