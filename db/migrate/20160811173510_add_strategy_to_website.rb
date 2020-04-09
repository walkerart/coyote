class AddStrategyToWebsite < ActiveRecord::Migration[5.1]
  def up
    add_column :websites, :strategy, :string
    w = Website.where(title: "MCA Chicago").first
    if w
      w.strategy = "MCAStrategy"
    end
  end
  def down
    remove_column :websites, :strategy
  end
end
