class SlashCommands::Calculator
  def self.cmd(bot)
    bot.register_application_command(:calcular, "Faz um cálculo simples") do |cmd|
      cmd.integer("primeiro_numero", "Primeiro número", required: true)
      cmd.string("operador", "Operação matemática", required: true, choices: { '+': "+", '-': "-", '*': "*", '/': "/" })
      cmd.integer("segundo_numero", "Segundo número", required: true)
    end

    bot.application_command(:calcular) do |event|
      first = event.options["primeiro_numero"]
      operation = event.options["operador"]
      second = event.options["segundo_numero"]
      Rails.logger.info "[/calcular] Solicitacao para calcular #{first} #{operation} #{second}"

      begin
        result = case operation
          when "+"
            first + second
          when "-"
            first - second
          when "*"
            first * second
          when "/"
            if second == 0
              "Erro: Divisão por zero não é permitida"
            else
              first.to_f / second # Realiza divisão real
            end
          else
            "Operação inválida"
          end

        field = [
          { name: "#{first} #{operation} #{second}", value: "= #{result}", inline: true },
        ]

        Rails.logger.info "[/calcular] Resultado: #{first} #{operation} #{second} = #{result}"
        Rails.logger.info "[/calcular] Respondendo ao user..."
        SendMessagesService.embed(event, "Calculadora", nil, fields: field)
      rescue StandardError => e
        event.respond(content: "Erro: #{e.message}", ephemeral: true)
      end
    end
  end
end
