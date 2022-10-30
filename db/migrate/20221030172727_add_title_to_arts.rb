class AddTitleToArts < ActiveRecord::Migration[7.0]
  def change
    add_column :arts, :title, :string
  end
end
