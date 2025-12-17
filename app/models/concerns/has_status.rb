module HasStatus
  extend ActiveSupport::Concern

  included do
    def status
      return :paid if paid_at.present?

      return :overdue if due_date < Date.today

      :pending
    end
  end
end
