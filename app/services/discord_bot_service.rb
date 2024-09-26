require "discordrb"

class DiscordBotService
  def initialize
    @bot = Discordrb::Commands::CommandBot.new(
      token: Enviroment.find_by(key: "DISCORD_BOT_TOKEN").value,
      client_id: Enviroment.find_by(key: "DISCORD_BOT_CLIENT_ID").value,
      prefix: "!",
    )
    @running = false
    CommandsService.new(@bot)
  end

  def start
    return if @running
    puts "#{Enviroment.find_by(key: "DISCORD_BOT_NAME").value} started!".green

    @running = true
    @bot_thread = Thread.new { @bot.run }
  end

  def stop
    bot_name = Enviroment.find_by(key: "DISCORD_BOT_NAME").value
    return unless @running
    puts "#{bot_name} being stoping...".yellow

    @running = false
    @bot.stop
    sleep(1)
    puts "#{bot_name} stoped, Bye!".blue
    @bot_thread.kill if @bot_thread
  end

  def running?
    @running
  end
end
