class AddTitleToImageForSearchability < ActiveRecord::Migration[5.1]
  def change
    add_column :images, :title, :text
  end
end
