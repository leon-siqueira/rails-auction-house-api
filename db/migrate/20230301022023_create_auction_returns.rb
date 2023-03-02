class CreateAuctionReturns < ActiveRecord::Migration[7.0]
  def change
    create_table :auction_returns do |t|
      t.references :auction, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.enum :kind, enum_type: :auction_return_kinds
      t.integer :value

      t.timestamps
    end
  end
end
