class CreateAuctionReturnKindsEnum < ActiveRecord::Migration[7.0]
  def up
    create_enum :auction_return_kinds, %w[covered_bid income]
  end

  def down
    execute <<-SQL
        DROP TYPE auction_return_kinds;
    SQL
  end
end
