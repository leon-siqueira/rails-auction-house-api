# frozen_string_literal: true

class CreateAuctionStatusEnum < ActiveRecord::Migration[7.0]
  def up
    create_enum :auction_status, %w[scheduled in_progress finished]
  end

  def down
    execute <<-SQL.squish
      DROP TYPE auction_status;
    SQL
  end
end
