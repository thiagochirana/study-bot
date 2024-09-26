class Playlist < ApplicationRecord
  has_many :musics, -> { order(:position) }
  before_destroy :reset_musics

  def start
    Rails.logger.info "[PLAYLIST] -> Inciando nova playlist"
    self.update(is_playing: true)
    musics.first if musics
  end

  def next_music
    current = current_music
    if current
      musics.where("position > ?", current.position).first
    else
      musics.first
    end
  end

  def add_to_list(music)
    next_position = last_to_play ? last_to_play.position + 1 : 1
    music.position = next_position
    musics << music # Adiciona a música à playlist
    Rails.logger.info "[PLAYLIST] -> Adicionado uma nova música: #{music[:title]}"
  end

  def last_to_play
    musics.last if musics
  end

  def play_music(music)
    Rails.logger.info "[PLAYLIST] -> Tocando agora: #{music[:title]}"
    musics.update_all(is_playing: false)
    music.update(is_playing: true)
  end

  def current_music
    musics.where(is_playing: true).first
  end

  def set_current_playing(music)
    current = current_music
    current.update(is_playing: false) if current
    music.update(is_playing: true)
  end

  private

  def reset_musics
    Rails.logger.info "[PLAYLIST] -> Deletada, metadados de músicas salvas serão mantidas... Até mais!"
    musics.update_all(is_playing: false, position: 0)
  end
end
