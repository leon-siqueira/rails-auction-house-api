class CreateTransactionKindEnums < ActiveRecord::Migration[7.0]
  def up
    create_enum :transaction_kinds, %w[bid deposit auction_gains refund]
  end

  def down
    execute <<-SQL
        DROP TYPE auction_status;
    SQL
  end
end
