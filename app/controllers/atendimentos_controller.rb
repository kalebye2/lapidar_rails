class AtendimentosController < ApplicationController

  before_action :set_atendimento, only: %i[ show edit update destroy reagendar_para_proxima_semana gerar_atendimento_valor create_atendimento_valor anotacoes_update anotacoes anotacoes_edit data data_update data_edit horario horario_update horario_edit status status_edit status_update declaracao_comparecimento modelo_relato instrumentos_usados new_instrumento_relato create_instrumento_relato ]
  before_action :validar_usuario
  before_action :validar_edicao, only: %i[ show edit update destroy reagendar_para_proxima_semana gerar_atendimento_valor ]

  def index
  end

  def show
    if params.has_key?(:ajax)
      if params.has_key?(:table) && params[:table] = true
        render partial: "atendimentos/atendimento-tabela-form", locals: { atendimento: @atendimento }
      else
        @instrumento_relatos = @atendimento.instrumento_relatos
        # redirect_to action: :instrumentos_usados, id: @atendimento.id
        render partial: "atendimentos/instrumentos_usados", locals: {instrumento_relatos: @instrumento_relatos, atendimento: @atendimento}
      end
    end
  end

  def new
    @atendimento = Atendimento.new
    @atendimento.build_atendimento_valor
  end

  def edit
    @atendimento.build_atendimento_valor unless @atendimento.atendimento_valor
  end

  def create
    @atendimento = Atendimento.new(atendimento_params)

    respond_to do |format|
      if @atendimento.save
        create_atendimento_valor
        format.html { redirect_to acompanhamento_url(@atendimento.acompanhamento), notice: "Atendimento registrado com sucesso!" }
        format.json { render :show, status: :created, location: @atendimento }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @atendimento.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_atendimento_valor
    if @atendimento.nil? then return end
    valor = @atendimento.build_atendimento_valor
    if !@atendimento.acompanhamento.atendimento_valores.last.nil?
      valor.taxa_porcentagem_externa = @atendimento.acompanhamento.atendimento_valores.last.taxa_porcentagem_externa
      valor.taxa_porcentagem_interna = @atendimento.acompanhamento.atendimento_valores.last.taxa_porcentagem_interna
      valor.valor = @atendimento.acompanhamento.valor_atual
      valor.save
    else
      valor.taxa_porcentagem_externa = 0
      valor.taxa_porcentagem_interna = 0
      valor.valor = @atendimento.acompanhamento.valor_atual
      valor.save
    end

    if params[:ajax].present?
      render partial: "atendimentos/atendimento-tabela-form", locals: {atendimento: @atendimento}
    end
  end

  def create_instrumento_relato
    if @atendimento.nil? then return end
    @instrumento_relato = InstrumentoRelato.new(instrumento_relato_params)
    @instrumento_relato.atendimento = @atendimento

    if @instrumento_relato.save
      if params.has_key?(:ajax)
        if params.has_key?(:table) && params[:table] = true
          render partial: "atendimentos/atendimento-tabela-form", locals: {atendimento: @atendimento}
        else
          render partial: "atendimentos/instrumentos_usados", locals: {atendimento: @atendimento, instrumento_relatos: @atendimento.instrumento_relatos}
        end
      end
    else
      render html: @instrumento_relato.errors.full_messages
    end
    # respond_to do |format|
    #   if @instrumento_relato.save
    #     format.html do
    #       if params.has_key?(:ajax)
    #         render partial: "atendimentos/atendimento-tabela-form", locals: {atendimento: @atendimento}
    #         return
    #       end
    #     end
    #   else
    #   end
    # end
  end

  def update
    respond_to do |format|
      if @atendimento.update(atendimento_params)
        format.html do
          if !params.has_key?(:ajax)
            redirect_to acompanhamento_url(@atendimento.acompanhamento), notice: "Atendimento atualizado com sucesso."
          else
            render partial: "atendimentos/atendimento-tabela-form", locals: {atendimento: @atendimento}
          end
        end
        format.json { render :show, status: :ok, location: @atendimento }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @atendimento.errors, status: :unprocessable_entity }
      end
    end
  end

  def instrumentos_usados
    @instrumento_relatos = @atendimento.instrumento_relatos
  end

  def new_instrumento_relato
    @request = request
  end

  # ajax

  def anotacoes_update
    if @atendimento.update(atendimento_params)
      render partial: "atendimentos/anotacoes_show", locals: { atendimento: @atendimento }
    end
  end

  def anotacoes
    render partial: "atendimentos/anotacoes_show", locals: { atendimento: @atendimento }
  end

  def anotacoes_edit
    render partial: "atendimentos/anotacoes_edit", locals: { atendimento: @atendimento }
  end

  def status_update
    if @atendimento.update(atendimento_params)
      #status
      if params.has_key?(:main)
        render partial: "atendimentos/atendimento-em-tabela", locals: {atendimento: @atendimento}
      else
      render partial: "atendimentos/atendimento-tabela-form", locals: {atendimento: @atendimento}
      end
    else
      status
    end
  end

  def status
    render partial: "atendimentos/status_show", locals: { atendimento: @atendimento }
  end

  def status_edit
    render partial: "atendimentos/status_edit", locals: { atendimento: @atendimento }
  end

  def modalidade_update
  end

  def modalidade
  end

  def modalidade_edit
  end

  def tipo_update
  end

  def tipo
  end

  def tipo_edit
  end

  def data_update
    if @atendimento.update(atendimento_params)
      render partial: "atendimentos/data_show", locals: { atendimento: @atendimento }
    end
  end

  def data
    render partial: "atendimentos/data_show", locals: { atendimento: @atendimento }
  end

  def data_edit
    render partial: "atendimentos/data_edit", locals: { atendimento: @atendimento }
  end

  def horario_update
    if @atendimento.update(atendimento_params)
      render partial: "atendimentos/horario_show", locals: { atendimento: @atendimento }
    end
  end

  def horario
    render partial: "atendimentos/horario_show", locals: { atendimento: @atendimento }
  end

  def horario_edit
    render partial: "atendimentos/horario_edit", locals: { atendimento: @atendimento }
  end

  def destroy
    if !@atendimento.atendimento_valor.nil?
      @atendimento.atendimento_valor.destroy
    end
    @atendimento.destroy

    respond_to do |format|
      format.html { redirect_to root_path, notice: "Atendimento removido com sucesso" }
      format.json { head :no_content }
    end
  end

  def gerar_atendimento_valor
    if @atendimento.atendimento_valor.nil?
      ultimo_atendimento_valor = @atendimento.acompanhamento.atendimento_valor.last || AtendimentoValor.new(valor: 0, desconto: 0, taxa_porcentagem_externa: 0, taxa_porcentagem_interna: 0)
      @atendimento.build_atendimento_valor(valor: ultimo_atendimento_valor.valor, taxa_porcentagem_externa: ultimo_atendimento_valor.taxa_porcentagem_externa, desconto: ultimo_atendimento_valor.desconto, taxa_porcentagem_interna: ultimo_atendimento_valor.taxa_porcentagem_interna).save!
      redirect_to @atendimento
    end
  end

  def reagendar_para_proxima_semana
    respond_to do |format|
      if @atendimento.update(data: @atendimento.data + 7.day, reagendado: @atendimento.data == Date.today)
        format.html { redirect_to atendimento_url(@atendimento), notice: "Atendimento agendado para a semana seguinte" }
        format.json { render :show, status: :ok, location: @atendimento }
      else
        format.html { render :show, status: :unprocessable_entity }
        format.json { render json: @atendimento.errors, status: :unprocessable_entity }
      end
    end
  end

  def declaracao_comparecimento
    respond_to do |format|
      format.html
      format.md do
        hoje = Time.now.strftime("%Y-%m-%d")
        hoje_formatado = Time.now.strftime("%d/%m/%Y")
        nome_documento = "#{@atendimento.pessoa.nome_completo.parameterize}_declaracao_#{hoje}"
        
        response.headers['Content-Type'] = 'text/markdown'
        #response.headers['Content-Disposition'] = "attachment; filename=#{nome_documento}.md"
      end
    end
  end

  def modelo_relato
    respond_to do |format|
      format.html
      format.md do
        nome_documento = "#{@atendimento.data}_#{@atendimento.horario.strftime("%H%M")}"

        response.headers['Content-Type'] = 'text/markdown'
        response.headers['Content-Disposition'] = "attachment; filename=#{nome_documento}.md"
      end
    end
  end

  private

  def set_atendimento
    @atendimento = Atendimento.find(params[:id])
  end

  def atendimento_params
    params.require(:atendimento).permit(:data, :horario, :horario_fim, :modalidade_id, :acompanhamento_id, :presenca, :atendimento_tipo_id, :anotacoes, :remarcado, :atendimento_local_id, :reagendado, atendimento_valor_attributes: [:atendimento_id, :valor, :desconto, :taxa_porcentagem_externa, :taxa_porcentagem_interna, :id], instrumento_relato_attributes: [:atendimento_id, :instrumento_id, :relato, :resultados, :observacoes])
  end

  def instrumento_relato_params
    params.require(:instrumento_relato).permit(:atendimento_id, :instrumento_id, :relato, :resultados, :observacoes)
  end

  def atendimento_instrumento_relato_params
    params.require(:atendimento).permit(instrumento_relato_attributes: %i[ atendimento_id instrumento_id relato resultados observacoes ])
  end

  def validar_usuario
    if usuario_atual.nil? || !((usuario_atual.corpo_clinico? && usuario_atual == @atendimento.profissional.usuario) || usuario_atual.secretaria?)
      render file: "#{Rails.root}/public/404.html", status: 403
      return
    end
  end

  def validar_edicao
    if !(usuario_atual.profissional == @atendimento.profissional || usuario_atual.secretaria?)
      render file: "#{Rails.root}/public/404.html", status: 403
      return
    end
  end
end
