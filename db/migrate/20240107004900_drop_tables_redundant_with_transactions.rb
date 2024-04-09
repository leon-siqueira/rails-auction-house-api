# frozen_string_literal: true

class DropTablesRedundantWithTransactions < ActiveRecord::Migration[7.0]
  # rubocop:disable Metrics/MethodLength
  def change
    drop_table :auction_returns do |t|
      t.references :auction, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.enum :kind, enum_type: :auction_return_kinds
      t.integer :value

      t.timestamps
    end

    drop_table :bids do |t|
      t.references :auction, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :value

      t.timestamps
    end
  end
  # rubocop:enable Metrics/MethodLength
end
