require 'rails_helper'

RSpec.describe Expense, type: :model do
  describe 'validations' do
    describe '#validate_category_percent' do
      # TODO: create an expense factory
      let(:transaction_attrs) { attributes_for(:expense, category_id: category.id) }
      let(:category) { create(:category, percent: percent) }

      context 'when category percent is present' do
        context 'with a single existing category' do
          context 'when percent sum is equal 100' do
            let(:percent) { 100 }

            it 'creates expense transaction' do
              expect { Expense.create!(transaction_attrs) }.to change(Expense, :count).by(1)
            end
          end

          context 'when percent sum is not equal 100' do
            let(:percent) { 50 }

            it 'does not create expense transaction' do
              expect { Expense.create!(transaction_attrs) }.to raise_error(ActiveRecord::RecordInvalid)
            end
          end
        end

        context 'with multiple existing categories' do
          before do
            create(:category, percent: 50)
            create(:category, percent: 30)
          end

          context 'when percent sum is equal 100' do
            let(:percent) { 20 }

            it 'creates expense transaction' do
              expect { Expense.create!(transaction_attrs) }.to change(Expense, :count).by(1)
            end
          end

          context 'when percent sum is not equal 100' do
            let(:percent) { 50 }

            it 'does not create expense transaction' do
              expect { Expense.create!(transaction_attrs) }.to raise_error(ActiveRecord::RecordInvalid)
            end
          end
        end
      end

      context 'when category percent is not present' do
        let(:percent) { nil }

        it 'creates expense transaction' do
          expect { Expense.create!(transaction_attrs) }.to change(Expense, :count).by(1)
        end
      end
    end
  end
end
