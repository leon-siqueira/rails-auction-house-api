class UpdateBalanceJob < ApplicationJob
  queue_as :default

  def perform(transaction)
    case transaction.kind
    when 'deposit', 'auction_income', 'covered_bid'
      transaction.receiver.update_balance
    when 'withdrawal', 'bid'
      transaction.giver.update_balance
    end
  end
end
