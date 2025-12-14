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

  describe '#is_invoice' do
    context 'when is_invoice is present' do
      let(:expense) { create(:expense, is_invoice: is_invoice, category_id: nil) }

      context 'and when is_invoice is true' do
        let(:is_invoice) { true }

        it 'allows creating an expense without category' do
          expect { expense }.to change(Expense, :count).by(1)
          expect(expense.category).to be_nil
        end
      end

      context 'and when is_invoice is false' do
        let(:is_invoice) { false }

        it 'does not allow creating an expense without category' do
          expect { expense }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end

      context 'and when is_invoice is not boolean' do
        let(:is_invoice) { 'foobar' }

        it 'does not allow creating an expense without category' do
          expect { expense }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end

    context 'when is_invoice is not present' do
      let(:expense) { create(:expense, category_id: nil) }

      it 'does not allow creating an expense without category' do
        expect { expense }.to raise_error(ActiveRecord::RecordInvalid)
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
