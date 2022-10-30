class CreateArts < ActiveRecord::Migration[7.0]
  def change
    create_table :arts do |t|
      t.string :author
      t.string :year
      t.string :description

      t.timestamps
    end
  end
end
