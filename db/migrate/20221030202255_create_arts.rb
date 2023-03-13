class CreateArts < ActiveRecord::Migration[7.0]
  def change
    create_table :arts do |t|
      t.string :author
      t.string :year
      t.string :title
      t.string :description
      t.references :creator, null: false, foreign_key: { to_table: :users }
      t.references :owner, null: false, foreign_key: { to_table: :users }


      t.timestamps
    end
  end
end
