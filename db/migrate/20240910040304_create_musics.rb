class CreateMusics < ActiveRecord::Migration[7.2]
  def change
    create_table :musics do |t|
      t.string :title
      t.string :description
      t.string :channel_title
      t.string :published_at
      t.string :thumbnail
      t.string :query_search
      t.string :link
      t.integer :position, default: 1
      t.string :path_mp3
      t.boolean :is_playing, default: false

      t.timestamps
    end
  end
end