class AddSearchTitleToSongs < ActiveRecord::Migration[4.2]
  def change
    add_column :songs, :search_title, :string
  end
end
