class CreateAuctions < ActiveRecord::Migration[7.0]
  def change
    create_table :auctions do |t|
      t.references :art, null: false, foreign_key: true
      t.string :description, null: false, default: ''
      t.integer :minimal_bid
      t.datetime :start_date
      t.datetime :end_date
      t.enum :status, enum_type: :auction_status

      t.timestamps
    end
  end
end
