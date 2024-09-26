class CreatePlaylists < ActiveRecord::Migration[7.2]
  def change
    create_table :playlists do |t|
      t.string :name
      t.boolean :is_playing, default: false
      t.timestamps
    end
  end
end
