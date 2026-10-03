class AddYearToSongs < ActiveRecord::Migration[4.2]
  def change
    add_column :songs, :year, :integer
  end
end
