require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:invoice_items) }
    it { is_expected.to belong_to(:payment_method) }
  end
end
