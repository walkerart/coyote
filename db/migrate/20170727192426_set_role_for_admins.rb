class SetRoleForAdmins < ActiveRecord::Migration[5.1]
  def change
    User.where(admin: true).update_all(role: 'admin')
    remove_column :users, :admin
  end
end
