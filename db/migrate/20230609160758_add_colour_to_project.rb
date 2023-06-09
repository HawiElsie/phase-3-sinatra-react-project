class AddColourToProject < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :colour, :string
  end
end
