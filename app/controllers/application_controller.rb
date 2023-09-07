class ApplicationController < ActionController::Base
  before_action :set_atendimentos, only: %i[ index update_tabela_atendimentos_hoje update_calendario_atendimentos_semnana ]

  def init
  end

  def index
  end

  def update_tabela_atendimentos_hoje
    render partial: 'application/atendimentos-hoje-tabela', locals: { atendimentos: @atendimentos_hoje }
  end

  def update_calendario_atendimentos_semana
    #atendimentos = Atendimento.da_semana(semana: @start_date.to_date.all_week)
    start_date = params[:start_date] || Date.today.beginning_of_week
    atendimentos = Atendimento.da_semana(semana: start_date.to_date.all_week)
    render partial: 'application/calendario-atendimentos-semana', locals: { events: atendimentos }
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

  private
  
  def autorizar_usuario
    #TODO
  end

  def abreviar
    string.split.map { |n| n[0] == n[0].downcase ? '' : n[0] }.join(". ") + '.'
  end

  def set_atendimentos
    @start_date = params[:start_date] || Date.today.beginning_of_week

    if usuario_atual.nil?
      @atendimentos = nil
    elsif usuario_atual.secretaria?
      @atendimentos = Atendimento.da_semana(semana: @start_date.to_date.all_week)
    else
      @atendimentos = usuario_atual.profissional.atendimentos.da_semana(semana: @start_date.to_date.all_week)
    end
    @atendimentos_hoje = Atendimento.de_hoje
  end

end
