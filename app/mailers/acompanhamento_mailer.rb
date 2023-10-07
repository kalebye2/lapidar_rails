class AcompanhamentoMailer < ActionMailer::Base
  default from: "notificacao@#{request.host}"

  def novo_acompanhamento_email
    @profissional = params[:profissional]
    @acompanhamento = params[:acompanhamento]
    @url = 'https://example.org'
    mail(to: @profissional.email, subject: "Novo acompanhamento registrado")
  end
end
