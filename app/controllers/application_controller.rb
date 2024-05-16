class ApplicationController < ActionController::Base
  before_action :set_atendimentos, only: %i[ update_tabela_atendimentos_hoje update_calendario_atendimentos_semnana ]

  before_action :usuario_logado, only: %i[ create update destroy ]

  def init
  end

  def index
    @database_exists = database_exists?
    if @database_exists
      set_atendimentos
      set_ajustes_futuros_usuario
    end
  end

  def configurar
    case params[:p]
    when 'tabelas'
      render html: "<h1>Tabelas</h1>"
    end
  end

  def ajuda
    if usuario_atual.nil?
      # request.headers["Content-Type"] = "text/markdown ; charset=utf-8"
      render file: "#{Rails.root}/public/404.html", status: 403
    else
      @texto = File.read("#{Rails.root}/public/ajuda.md")
    end
  end

  def update_tabela_atendimentos_hoje
    render partial: 'application/atendimentos-hoje-tabela', locals: { atendimentos: @atendimentos_hoje }
  end

  def update_calendario_atendimentos_semana
    #atendimentos = Atendimento.da_semana(semana: @start_date.to_date.all_week)
    start_date = params[:start_date].to_date || Date.today.beginning_of_week
    atendimentos = Atendimento.da_semana(semana: start_date.to_date.all_week)
    render partial: 'application/calendario-atendimentos-semana', locals: { events: atendimentos, start_date: start_date }
  end

  def usuario_atual
    begin
      @usuario_atual ||= Usuario.find(session[:usuario_id]) if session[:usuario_id]
    rescue ActiveRecord::RecordNotFound => e
      @usuario_atual = nil
      session[:usuario_id] = nil
      redirect_to root_path
      return
    end
  end
  helper_method :usuario_atual

  def pdf_download
    pdf = Prawn::Document.new
    pdf.text "Hello World!"
    send_data(pdf.render,
              filename: "hello.pdf",
             type: "application/pdf")
  end


  def pdf_preview
    pdf = Prawn::Document.new
    pdf.text "This is a preview"

    pdf.start_new_page
    pdf.text "New Page"
    1000.times do |i|
      pdf.text "Line #{i}"
    end
    send_data(pdf.render,
              filename: "preview.pdf",
             type: "application/pdf",
             disposition: "inline")
  end


  def execute_statement(sql)
    results = ActiveRecord::Base.connection.execute(sql)

    if results.present?
      return results
    else
      return nil
    end
  end

  # 403 que parece 404
  def erro403 mensagem = ""
    # NavegacaoErro.create(remote_ip: request.remote_ip, data: Date.current, horario: Time.current, request_url: request.original_url, error_code: 403, mensagem: mensagem.to_s)
    criar_erro_de_navegacao
    render file: "#{Rails.root}/public/404.html", status: 403
  end

  def criar_erro_de_navegacao **kwargs
    mensagem = kwargs[:mensagem].presence || "Tentativa de requisição de #{usuario_atual&.username&.insert(-1, " (id: #{usuario_atual&.id})") || "usuário não identificado"}."
    NavegacaoErro.create(remote_ip: request.remote_ip, data: Date.current, horario: Time.current, request_url: request.path, error_code: kwargs[:error_code] || 403, mensagem: mensagem.to_s)
  end

  def nome_do_site
    Rails.application.config.app_name || Rails.application.class.module_parent_name.to_s
  end
  alias site_name nome_do_site

  private

  def usuario_logado
    !usuario_atual.nil?
  end
  
  def checar *condicoes
    condicoes.each do |condicao|
      if condicao then return true end
    end
    return false
  end

  def nao_checar *condicoes
    !checar condicoes
  end

  def hx_request?
    request.headers["HX-Request"].presence
  end

  def abreviar
    string.split.map { |n| n[0] == n[0].downcase ? '' : n[0] }.join(". ") + '.'
  end

  def set_atendimentos
    @start_date = params[:start_date] || Date.today.beginning_of_week

    if usuario_atual.nil?
      @atendimentos = nil
    elsif usuario_atual.secretaria?
      @atendimentos = Atendimento.da_semana(semana: @start_date.to_date.all_week).or(Atendimento.reagendados_da_semana(semana: @start_date.to_date.all_week))
    else
      @atendimentos = usuario_atual.profissional.atendimentos.da_semana(semana: @start_date.to_date.all_week)
    end
    @atendimentos_hoje = Atendimento.de_hoje.or(Atendimento.where(data_reagendamento: Date.today)).sort_by(&:horario_inicio_verdadeiro)
  end

  def database_exists?
    ActiveRecord::Base.connection
  rescue ActiveRecord::NoDatabaseError
    false
  else
    !database_empty?
  end

  def database_empty?
    ActiveRecord::Base.connection.data_sources.empty?
  end

  def set_ajustes_futuros_usuario
    @reajustes_futuros = usuario_atual&.profissional&.acompanhamento_reajustes&.ajustes_futuros&.nao_aplicados&.order(data_ajuste: :desc)
  end
end
