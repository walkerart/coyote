class UpdateMcaurl < ActiveRecord::Migration[5.1]
  def change
    w = Website.where(title: "MCA Chicago").first
    if w
      w.url = "https://mcachicago.org"
      w.save
    end
  end
end
