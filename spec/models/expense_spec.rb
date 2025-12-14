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

  describe '#status' do
    context 'when paid_at is nil' do
      context 'and due_date is in the past' do
        let(:expense) { create(:expense, :overdue) }

        it 'returns :overdue' do
          expect(expense.status).to eq(:overdue)
        end
      end

      context 'and due_date is not in the past' do
        let(:expense) { create(:expense) }

        it 'returns :pending' do
          expect(expense.status).to eq(:pending)
        end
      end
    end

    context 'when paid_at is not nil' do
      let(:expense) { create(:expense, :paid) }

      it 'returns :paid' do
        expect(expense.status).to eq(:paid)
      end
    end
  end
end
