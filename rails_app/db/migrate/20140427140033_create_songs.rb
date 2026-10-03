class CreateSongs < ActiveRecord::Migration[4.2]
  def change
    create_table :songs do |t|
      t.string :title
      t.string :composer
      t.string :lyricist

      t.timestamps
    end
  end
end
