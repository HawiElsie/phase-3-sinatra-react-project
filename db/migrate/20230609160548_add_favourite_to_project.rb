class AddFavouriteToProject < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :favourite, :boolean
  end
end
