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
    when 'pessoa'
      if Pessoa.count > 0
        redirect_to configurar_path(p: "profissional")
      else
        @pessoa = Pessoa.new
        render partial: "primeira-pessoa-form", locals: { pessoa: @pessoa }
      end
    when "profissional"
      if Profissional.count > 0
        redirect_to configurar_path(p: "usuario")
      else
        @profissional = Profissional.new(pessoa: Pessoa.first)

        if !@profissional
          redirect_to configurar_path(p: "pessoa")
        else
          render partial: "primeiro-profissional-form", locals: { profissional: @profissional }
        end
      end
    when "usuario"
      @usuario = Usuario.new(profissional: Profissional.first)

      if !@usuario
        redirect_to configurar_path(p: "profissional")
      else
        render partial: "primeiro-usuario-form", locals: { usuario: @usuario }
      end
    end
  end

  def registrar_pessoa
    return if Pessoa.count > 0
    @pessoa = Pessoa.new pessoa_params
    if @pessoa.save
      redirect_to configurar_path(p: "profissional")
    else
      render partial: "primeira-pessoa-form", status: :unprocessable_entity, locals: { pessoa: @pessoa }
    end
  end

  def registrar_profissional
    return if Profissional.count > 0
    @profissional = Profissional.new profissional_params
    if @profissional.save
      redirect_to configurar_path(p: "profissional")
    else
      render partial: "primeiro-profissional-form", status: :unprocessable_entity, locals: { profissional: @profissional }
    end
  end

  def registrar_usuario
    return if Usuario.count > 0
    @usuario = Usuario.new usuario_params
    if @usuario.save
      render partial: "application/index-padrao"
    else
      render partial: "primeiro-usuario-form", status: :unprocessable_entity, locals: { usuario: @usuario }
    end
  end

  def ajuda
    charset = "charset=utf-8"

    if usuario_atual.nil?
      # request.headers["Content-Type"] = "text/markdown ; charset=utf-8"
      render file: "#{Rails.root}/public/404.html", status: 403
    else
      @texto = File.read("#{Rails.root}/public/ajuda.md")
    end

    respond_to do |format|
      format.html

      format.md do
        headers["Content-Type"] = "text/html; charset=utf-8"
        render html: "Hi"
      end

      format.pdf do
        pdf = AjudaPdf.new
        send_data pdf.render,
          filename: "Lapidar_ajuda_aplicacao.pdf",
          type: "application/pdf",
          disposition: :inline
      end
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

  def centificar_numero numero
    valor_final = numero&.to_s || "0,00"

    if !valor_final.include?(",")
      valor_final += ","
    end

    valor_final.gsub!(".", "")
    index_virgula = valor_final.index(",")
    valor_inteiros = valor_final[..index_virgula - 1]
    valor_decimais = ((valor_final[index_virgula + 1..]) + "00")[..1]

    "#{valor_inteiros}#{valor_decimais}".gsub(",", "").to_i
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

  def set_de_ate de = Date.current.beginning_of_month, ate = Date.current.end_of_month
    @de = params[:de]&.to_date || de
    @ate = params[:ate]&.to_date || ate
  end
  alias de_ate_params set_de_ate

  def pessoa_params
    params.require(:pessoa).permit *Pessoa.attribute_names
  end

  def profissional_params
    params.require(:profissional).permit *Profissional.attribute_names
  end

  def usuario_params
    params.require(:usuario).permit %i[ profissional_id username password password_confirmation admin corpo_clinico secretaria financeiro informatica ]
  end

  def nome_documento
    "#{nome_do_site&.parameterize}_#{params[:controller]}_#{@params.to_h.compact.map { |k,v| "#{k&.to_s}=#{v&.to_s}"}.join "_"}__#{Time.current.to_fs(:number)}"
  end

  def compor_valor_monetario_de_virgulas valor
      valor_final = valor&.to_s || "0,00"
      valor_final += "," unless valor_final.include?(",")
      valor_final.gsub!(".", "")
      index_virgula = valor_final.index(",")
      valor_decomposto = {}
      valor_decomposto[:inteiros] = valor_final[..index_virgula - 1]
      valor_decomposto[:centavos] = ((valor_final[index_virgula + 1..]) + "00")[..1]
      valor_final = "#{valor_decomposto[:inteiros]}#{valor_decomposto[:centavos]}".to_i
  end
end
