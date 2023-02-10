class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.enum :kind, enum_type: :transaction_kinds
      t.integer :value
      t.references :origin, null: false, polymorphic: true, index: true
      t.references :target, null: false, polymorphic: true, index: true

      t.timestamps
    end
  end
end
