# frozen_string_literal: true

class DropTablesRedundantWithTransactions < ActiveRecord::Migration[7.0]
  def change
    drop_table :auction_returns, if_exists: true
    drop_table :bids, if_exists: true
  end
end
