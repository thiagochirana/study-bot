class PrefixedCommands::PlayMusic
  def self.cmd(bot)
    bot.register_application_command(:play, "Ouvir uma música") do |cmd|
      cmd.string("musica", "Insira o nome da música ou link do Youtube", required: true)
    end

    bot.application_command(:play) do |event|
      name_music = event.options["musica"]
      if name_music.nil?
        SendMessagesService.embed(event, "Oops...", "Não se pode pesquisar sem algum nome de música ou link")
        return
      end

      playlist = Playlist.find_or_create_by(name: "playlist_#{ENV["DISCORD_BOT_NAME"]}")

      # Primeiro busca localmente se já não tem algo 'pronto'
      music = Music.where("link = ? OR query_search = ?", name_music, name_music).first

      unless music && music[:link]
        data = Youtube::SearchService.music(name_music)
        music = Music.create(
          title: data[:title],
          description: data[:description],
          channel_title: data[:channel_title],
          published_at: data[:published_at],
          thumbnail: data[:thumbnail],
          query_search: name_music,
          link: data[:link],
          playlist: playlist,
        )
      end

      arq = Youtube::ArchiveService.download_mp3(music[:link], music[:id])
      music.update(path_mp3: arq[:file_path]) unless music[:path_mp3]

      # Reproduz o áudio
      reproduce_audio(event, bot, music)
    end
  end

  def self.reproduce_audio(event, bot, music)
    # Obtém o canal de voz do usuário
    channel = event.user.voice_channel
    unless channel
      SendMessagesService.embed(event, "Oops...", "Você não está em um canal de voz!")
      return
    end

    voice_bot = event.bot.voice_connect(channel)
    Rails.logger.info "Bot conectado ao canal de voz"
    SendMessagesService.embed(event, "Conectado", "Bot conectado ao canal de voz")

    sleep(1)
    # Reproduz o arquivo de música
    voice_bot.play_file(music[:path_mp3])
  end
end
