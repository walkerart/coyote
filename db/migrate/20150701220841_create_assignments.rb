class CreateAssignments < ActiveRecord::Migration[5.1]
  def change
    create_table :assignments do |t|
      t.references :user, index: true, foreign_key: true
      t.references :image, index: true, foreign_key: true

      t.timestamps
    end
  end
end
