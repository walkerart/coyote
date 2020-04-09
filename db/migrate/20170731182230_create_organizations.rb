class CreateOrganizations < ActiveRecord::Migration[5.1]
  def change
    create_table :organizations do |t|
      t.text :title

      t.timestamps null: false
    end
  end
end
