# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.references :giver, polymorphic: true
      t.references :receiver, polymorphic: true
      t.integer :amount
      t.enum :kind, enum_type: :transaction_kinds

      t.timestamps
    end
  end
end
