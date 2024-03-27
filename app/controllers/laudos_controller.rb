class LaudosController < ApplicationController
  before_action :set_laudo, only: %i[ show edit update delete data_final data_final_edit identificacao_update informacoes_update interessado interessado_edit finalidade finalidade_edit demanda demanda_edit tecnicas tecnicas_edit analise analise_edit conclusao conclusao_edit referencias referencias_edit]
  before_action :validar_usuario

  include Pagy::Backend

  def index
    if usuario_atual.secretaria?
      @laudos = Laudo.order(data_avaliacao: :desc)
    elsif usuario_atual.corpo_clinico?
      @laudos = usuario_atual.profissional.laudos.order(data_avaliacao: :desc)
    end

    @de = params[:de]&.to_date || Laudo.minimum(:data_avaliacao)
    @ate = params[:ate]&.to_date || Laudo.maximum(:data_avaliacao)

    if params[:status].present?
      if params[:status].to_sym == :fechado
        @laudos = @laudos.fechados
      elsif params[:status].to_sym == :aberto
        @laudos = @laudos.abertos
      end
    end

    if params[:paciente].present?
      like =  params[:paciente].to_s
      query = "LOWER(pessoas.nome || ' ' || COALESCE(pessoas.nome_do_meio, '') || ' '|| pessoas.sobrenome) LIKE ?", "%#{like}%"
      if Rails.configuration.database_configuration[Rails.env]["adapter"].downcase == "mysql"
        query = "LOWER(CONCAT(pessoas.nome, ' ', COALESCE(pessoas.nome_do_meio, ''), ' ', pessoas.sobrenome)) LIKE ?", "%#{like}%"
      end
      @laudos = @laudos.joins(:pessoa).where(query)
    end

    @laudos = @laudos.where(data_avaliacao: @de..@ate)

    @contagem = @laudos.count
    @pagy, @laudos = pagy(@laudos, items: 9)
    @params = params.permit(:de, :ate, :profissional, :status, :acompanhamento, :paciente)
  end

  def show
    respond_to do |format|
      format.md do
        response.headers['Content-Type'] = 'text/markdown'
        response.headers['Content-Disposition'] = "attachment; filename=laudo_#{@laudo.paciente.nome_completo.parameterize}_#{@laudo.data_avaliacao}.md"
      end
      format.html
      format.pdf do
        info = {
          Title: "Laudo",
        }
        pdf = LaudoPdf.new(@laudo)
        filename = "#{@laudo.profissional.nome_completo.parameterize}_laudo_#{@laudo.profissional.profissional_funcao.adjetivo_masc}_#{@laudo.pessoa.nome_completo.parameterize}_#{@laudo.data_avaliacao}.pdf"
        send_data pdf.render, filename: filename, type: "application/pdf", disposition: :inline
      end
    end
  end

  def new
    @laudo = Laudo.new
  end

  def create
    @laudo = Laudo.new(laudo_params)

    respond_to do |format|
      if @laudo.save
        format.html { redirect_to laudo_url(@laudo), notice: "laudo was successfully created." }
        format.json { render :show, status: :created, location: @laudo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @laudo.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @laudo.update(laudo_params)
        if hx_request?
          format.html { render :show }
        else
        format.html { redirect_to laudo_url(@laudo), notice: "laudo was successfully updated." }
        format.json { render :show, status: :ok, location: @laudo }
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @laudo.errors, status: :unprocessable_entity }
      end
    end
  end

  def delete
  end

  # ajax much

  def identificacao_update
    if @laudo.update(laudo_params)
      render partial: "laudos/tabela-identificacao", locals: { laudo: @laudo }
    end
  end

  def informacoes_update
    if @laudo.update(laudo_params)
      render partial: "laudos/tabela-informacoes", locals: { laudo: @laudo }
    end
  end
  
  def data_final
    render partial: "laudos/tabela-identificacao/laudo-avaliacao-data-final", locals: { laudo: @laudo }
  end

  def data_final_edit
    render partial: "laudos/tabela-identificacao/laudo-avaliacao-data-final-edit", locals: { laudo: @laudo }
  end

  def interessado
    render partial: "laudos/tabela-identificacao/laudo-interessado", locals: { laudo: @laudo }
  end

  def interessado_edit
    render partial: "laudos/tabela-identificacao/laudo-interessado-edit", locals: { laudo: @laudo }
  end

  def finalidade
    render partial: "laudos/tabela-identificacao/laudo-finalidade", locals: { laudo: @laudo }
  end

  def finalidade_edit
    render partial: "laudos/tabela-identificacao/laudo-finalidade-edit", locals: { laudo: @laudo }
  end

  def demanda
    render partial: "laudos/tabela-identificacao/laudo-demanda", locals: { laudo: @laudo }
  end

  def demanda_edit
    render partial: "laudos/tabela-identificacao/laudo-demanda-edit", locals: { laudo: @laudo }
  end

  def tecnicas
    render partial: "laudos/tabela-informacoes/laudo-tecnicas", locals: { laudo: @laudo }
  end

  def tecnicas_edit
    render partial: "laudos/tabela-informacoes/laudo-tecnicas-edit", locals: { laudo: @laudo }
  end

  def analise
    render partial: "laudos/tabela-informacoes/laudo-analise", locals: { laudo: @laudo }
  end

  def analise_edit
    render partial: "laudos/tabela-informacoes/laudo-analise-edit", locals: { laudo: @laudo }
  end

  def conclusao
    render partial: "laudos/tabela-informacoes/laudo-conclusao", locals: { laudo: @laudo }
  end

  def conclusao_edit
    render partial: "laudos/tabela-informacoes/laudo-conclusao-edit", locals: { laudo: @laudo }
  end

  def referencias
    render partial: "laudos/tabela-informacoes/laudo-referencias", locals: { laudo: @laudo }
  end

  def referencias_edit
    render partial: "laudos/tabela-informacoes/laudo-referencias-edit", locals: { laudo: @laudo }
  end

  private

  def set_laudo
    if usuario_atual.secretaria?
      @laudo = Laudo.find(params[:id])
    else
      begin
        @laudo = usuario_atual.profissional.laudos.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        @laudo = nil
        render file: "#{Rails.root}/public/404.html", status: 403
      end
    end
  end

  def laudo_params
    params.require(:laudo).permit(:acompanhamento_id, :interessado, :data_avaliacao, :finalidade, :demanda, :tecnicas, :analise, :conclusao, :referencias, :fechado)
  end

  def validar_usuario
    if usuario_atual.nil? || !(usuario_atual.corpo_clinico? || usuario_atual.secretaria?)
      render file: "#{Rails.root}/public/404.html", status: 403
    end
  end
end
