class AddImgUrlToArts < ActiveRecord::Migration[7.0]
  def change
    add_column :arts, :img_url, :string
  end
end
