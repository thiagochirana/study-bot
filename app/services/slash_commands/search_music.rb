class SlashCommands::SearchMusic
  def self.cmd(bot)
    bot.register_application_command(:search, "Busque uma música no Youtube") do |cmd|
      cmd.string("musica", "Insira o nome da música a ser buscada no Youtube", required: true)
    end
    bot.application_command(:search) do |event|
      name = event.options["musica"]
      result = Youtube::SearchService.music name

      if result[:found]
        field = [
          { name: "Link", value: r[:link], inline: false },
          { name: "Canal", value: r[:channel_title], inline: false },
        ]
        SendMessagesService.embed(
          event,
          result[:title],
          result[:description],
          url_image: result[:thumbnail],
          text_footer: "Vídeo lançado em #{result[:published_at]}",
          fields: field,
        )
      else
        SendMessagesService.embed(event, "Oops...", "\"#{name}\" não foi encontrado")
      end

      result
    end
  end
end
