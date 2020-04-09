class AddDescriptionsCountToImages < ActiveRecord::Migration[5.1]
  def change
    add_column :images, :descriptions_count, :integer, default: 0
  end
end
