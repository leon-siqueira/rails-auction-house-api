# frozen_string_literal: true

class CreateTransactionKinds < ActiveRecord::Migration[7.0]
  def up
    create_enum :transaction_kinds, %w[deposit withdrawal auction_income bid covered_bid]
  end

  def down
    execute <<-SQL
        DROP TYPE transaction_kinds;
    SQL
  end
end
