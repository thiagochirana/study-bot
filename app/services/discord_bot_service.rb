require "discordrb"

class DiscordBotService
  def initialize
    @bot = Discordrb::Commands::CommandBot.new(
      token: ENV["DISCORD_BOT_TOKEN"],
      client_id: ENV["DISCORD_BOT_CLIENT_ID"],
      prefix: "!",
    )
    @running = false
    CommandsService.new(@bot)
  end

  def start
    return if @running
    puts "#{ENV["DISCORD_BOT_NAME"]} started!".green

    @running = true
    @bot_thread = Thread.new { @bot.run }
  end

  def stop
    return unless @running
    puts "#{ENV["DISCORD_BOT_NAME"]} being stoping...".yellow

    @running = false
    @bot.stop
    sleep(1)
    puts "#{ENV["DISCORD_BOT_NAME"]} stoped, Bye!".blue
    @bot_thread.kill if @bot_thread
  end

  def running?
    @running
  end
end
