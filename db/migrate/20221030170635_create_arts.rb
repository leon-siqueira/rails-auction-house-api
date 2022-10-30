class CreateArts < ActiveRecord::Migration[7.0]
  def change
    create_table :arts do |t|
      t.string :title
      t.string :description
      t.string :year

      t.timestamps
    end
  end
end
