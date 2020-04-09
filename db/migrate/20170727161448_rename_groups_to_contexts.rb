class RenameGroupsToContexts < ActiveRecord::Migration[5.1]
  def change
    rename_table :groups, :contexts
  end
end
