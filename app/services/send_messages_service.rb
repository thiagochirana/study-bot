class SendMessagesService
  def self.embed(event, title, description, colour: 0x00ff00, fields: [], url_image: nil, timestamp: Time.now, text_footer: nil, only_author_see: false)
    embed = Discordrb::Webhooks::Embed.new(
      title: title,
      colour: colour,
      timestamp: timestamp,
    )

    embed.description = description if description
    embed.image = Discordrb::Webhooks::EmbedImage.new(url: url_image) if url_image
    embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: text_footer) if text_footer

    fields.each do |f|
      embed.add_field(name: f[:name], value: f[:value], inline: f[:inline])
    end

    Rails.logger.info "Respondendo o comando #{event.command_name}"
    event.respond(embeds: [embed], ephemeral: only_author_see)
  end
end
