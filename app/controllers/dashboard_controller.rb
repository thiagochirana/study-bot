class DashboardController < ApplicationController
  def index
  end

  def start_bot
    @disc_bot = DiscordBotService.new
    @disc_bot.start
    render json: { message: "Bot foi iniciado com sucesso" }, status: :ok
  end

  def stop_bot
    @disc_bot.start
    render json: { message: "Bot foi parado com sucesso" }, status: :ok
  end
end
