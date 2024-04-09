# frozen_string_literal: true

class CreateRoleKindsEnum < ActiveRecord::Migration[7.0]
  def up
    create_enum :role_kinds, %w[admin artist buyer auctioneer]
  end

  def down
    execute <<-SQL
        DROP TYPE role_kinds;
    SQL
  end
end
