class Transaction < ApplicationRecord
end

# == Schema Information
#
# Table name: transactions
#
#  id          :integer          not null, primary key
#  amount      :decimal(, )      not null
#  type        :string           not null
#  due_date    :date             not null
#  description :text
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_transactions_on_category_id  (category_id)
#
