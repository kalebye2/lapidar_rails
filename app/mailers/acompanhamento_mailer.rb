class AcompanhamentoMailer < ApplicationMailer
  default from: "notificacao@email.com"

  def novo_acompanhamento(profissional: Profissional.first, acompanhamento: Acompanhamento.last)
    @profissional = profissional
    @acompanhamento = acompanhamento
    @url = 'https://example.org'
    mail(to: @profissional.email, subject: "Novo acompanhamento registrado")
  end

  def test
    @greeting = "hi"

    mail to: "to@example.org"
  end
end
