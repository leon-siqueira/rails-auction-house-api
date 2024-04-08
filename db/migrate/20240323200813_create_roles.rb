class CreateRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :roles do |t|
      t.enum :kind, enum_type: :role_kinds
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
