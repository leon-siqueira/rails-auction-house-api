class CreateAuctionStatusEnum < ActiveRecord::Migration[7.0]
  def up
    create_enum :auction_status, %w[scheduled in_progress finished]
  end

  def down
    # While there is a `create_enum` method, there is no way to drop it. You can
    # how ever, use raw SQL to drop the enum type.
    execute <<-SQL
      DROP TYPE auction_status;
    SQL
  end
end
