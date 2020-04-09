class AddLicenseToDescriptions < ActiveRecord::Migration[5.1]
  def change
    add_column :descriptions, :license, :string, default: "cc0-1.0"
  end
end
