class AddCanonicalIdToImage < ActiveRecord::Migration[5.1]
  def change
    add_column :images, :canonical_id, :string
  end
end
