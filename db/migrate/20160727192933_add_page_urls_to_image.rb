class AddPageUrlsToImage < ActiveRecord::Migration[5.1]
  def change
    add_column :images, :page_urls, :text
  end
end
