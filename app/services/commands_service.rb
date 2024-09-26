# frozen_string_literal: true

require "discordrb"

class CommandsService
  def initialize(bot)
    @bot = bot
    start_slash_commands
    start_prefix_commands
  end

  def start_slash_commands
    SlashCommands::Calculator.cmd @bot
    SlashCommands::SearchMusic.cmd @bot
  end

  def start_prefix_commands
    PrefixedCommands::PlayMusic.cmd @bot
  end
end
