class AddPlaylistIdToMusics < ActiveRecord::Migration[7.2]
  def change
    add_column :musics, :playlist_id, :integer
  end
end
