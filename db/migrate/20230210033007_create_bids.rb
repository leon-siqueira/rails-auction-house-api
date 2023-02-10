class CreateBids < ActiveRecord::Migration[7.0]
  def change
    create_table :bids do |t|

      t.timestamps
    end
  end
end
