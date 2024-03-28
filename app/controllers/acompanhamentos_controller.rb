class AcompanhamentosController < ApplicationController
  before_action :set_acompanhamento, except: %i[ index new create]
  before_action :validar_usuario
  before_action :validar_edicao, only: %i[ edit update destroy ]
  include Pagy::Backend

  def index
    if !(usuario_atual.secretaria? || usuario_atual.corpo_clinico?)
      erro403
      return
    end

    @acompanhamentos = Acompanhamento.all.order(data_inicio: :desc)
    # filtrar
    if params[:tipo].presence
      @acompanhamentos = @acompanhamentos.where(acompanhamento_tipo_id: params[:tipo])
    end

    if params[:status].present?
      case params[:status].to_sym
      when :em_andamento
        @acompanhamentos = @acompanhamentos.em_andamento
      when :finalizado
        @acompanhamentos = @acompanhamentos.finalizados
      when :suspenso
        @acompanhamentos = @acompanhamentos.suspensos
      end
    end

    if params[:profissional].presence
      @acompanhamentos = @acompanhamentos.do_profissional_com_id(params[:profissional])
    end

    if params[:pessoa].present?
      like =  params[:pessoa].to_s
      @acompanhamentos = @acompanhamentos.query_pessoa_like_nome(like)
    end
    if params[:responsavel].present?
      like =  params[:responsavel].to_s
      @acompanhamentos = @acompanhamentos.query_responsavel_like_nome(like)
    end

    @pagy, @acompanhamentos = pagy(@acompanhamentos, items: 9)
    @params = params.permit(:tipo, :status, :profissional, :paciente)

    if hx_request?
      render partial: "acompanhamentos-container", locals: { acompanhamentos: @acompanhamentos }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.pdf do
        nome_documento = "dados-acompanhamento_#{@acompanhamento.pessoa.nome_completo.parameterize}_#{@acompanhamento.data_inicio}_#{@acompanhamento.tipo}"
        pdf = AcompanhamentoDadosPdf.new(@acompanhamento)
        send_data pdf.render,
          filename: "#{nome_documento}.pdf",
          type: "application/pdf",
          disposition: :inline
      end
      format.json
    end
  end

  def new
    @acompanhamento = Acompanhamento.new
  end

  def edit
  end

  def create
    if !@pessoa.nil? then acompanhamento_params[:pessoa_id] = @pessoa.id end
    if !@profissional.nil? then profissional_params[:profissional_id] = @profissional.id end
    @acompanhamento = Acompanhamento.new(acompanhamento_params)
    # colocar as informações no sistema
    @acompanhamento.num_sessoes = @acompanhamento.num_sessoes_contrato
    @acompanhamento.valor_sessao = @acompanhamento.valor_sessao_contrato

    respond_to do |format|
      if @acompanhamento.save
        atendimento = Atendimento.create(acompanhamento: @acompanhamento, data: @acompanhamento.data_inicio, horario: params[:horario_primeira_consulta] || "08:00", atendimento_tipo_id: params[:tipo_primeira_consulta] || AtendimentoTipo.first.id, modalidade_id: params[:modalidade_primeira_consulta] || AtendimentoModalidade.first)
        format.html { redirect_to acompanhamento_url(@acompanhamento), notice: "Acompanhamento registrado com sucesso!" }
        format.json { render :show, status: :created, location: @acompanhamento }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @acompanhamento.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if !@pessoa.nil? then acompanhamento_params[:pessoa_id] = @pessoa.id end
      if !@profissional.nil? then acompanhamento_params[:profissional_id] == @profissional.id end
      if @acompanhamento.update(acompanhamento_params)
        if hx_request?
          format.html do
            render :show
          end
        else
        format.html { redirect_to acompanhamento_url(@acompanhamento), notice: "acompanhamento was successfully updated." }
        format.json { render :show, status: :ok, location: @acompanhamento }
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @acompanhamento.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @acompanhamento.destroy
    
    respond_to do |format|
      format.html { redirect_to acompanhamentos_url, notice: "Acompanhamento excluído com sucesso!" }
      format.json { head :no_content }
    end
  end


  def prontuario
    respond_to do |format|
      format.html

      format.md do
        hoje = Time.now.strftime("%Y-%m-%d")
        hoje_formatado = Time.now.strftime("%d/%m/%Y")
        nome_documento = "#{@acompanhamento.pessoa.nome_completo.parameterize}_prontuario-#{@acompanhamento.tipo.parameterize}_#{hoje}"
        
        response.headers['Content-Type'] = 'text/markdown'
        response.headers['Content-Disposition'] = "attachment; filename=#{nome_documento}.md"
      end

      format.pdf do
        hoje = Time.now.strftime("%Y-%m-%d")
        hoje_formatado = Time.now.strftime("%d/%m/%Y")
        nome_documento = "#{@acompanhamento.pessoa.nome_completo}_caso-detalhes_#{hoje}"

        prontuario_options = {
          trans: params[:trans],
          orientacao_sexual: params[:orientacao_sexual],
        }
        pdf = AcompanhamentoDetalhesPdf.new(@acompanhamento, options: prontuario_options)

        send_data(pdf.render,
                  filename: "#{nome_documento}.pdf",
                  type: "application/pdf",
                  disposition: "inline"
                 )
      end

    end
  end
  alias caso_detalhes prontuario

  def new_atendimento_semana_seguinte
    @acompanhamento = params[:controller] == "acompanhamentos" ? Acompanhamento.find(params[:id]) : Acompanhamento.find(params[:acompanhamento_id])
    # retorna se não for secretária que trabalha o dia inteiro comigo ou o profissional responsável
    if @acompanhamento.profissional != usuario_atual.profissional
      redirect_to acompanhamento_path(@acompanhamento), notice: "Não senhor!"
      return
    end
    semanas_pra_passar = 4 / @acompanhamento.num_sessoes

    au = @acompanhamento.atendimentos.em_ordem.last
    atendimento = @acompanhamento.atendimentos.new
    auvalor = au.atendimento_valor
    avalor = atendimento.build_atendimento_valor
    atendimento.data = au.data + semanas_pra_passar.week
    atendimento.horario = au.horario
    atendimento.horario_fim = au.horario_fim
    atendimento.modalidade_id = au.modalidade_id
    atendimento.atendimento_local_id = au.atendimento_local_id
    atendimento.atendimento_tipo_id = au.atendimento_tipo_id
    avalor.valor = @acompanhamento.valor_sessao
    avalor.taxa_porcentagem_interna = auvalor.taxa_porcentagem_interna
    avalor.taxa_porcentagem_externa = auvalor.taxa_porcentagem_externa

    atendimento.save!
    avalor.save!
    #atendimento = @acompanhamento.atendimento.create(data: au.data + 7.day, horario: au.horario, modalidade_id: au.modalidade_id, atendimento_local_id: au.atendimento_local_id, atendimento_tipo_id: au.atendimento_tipo_id)
    redirect_to @acompanhamento, notice: "Novo atendimento registrado"
  end

  def new_atendimento_proxima_semana
    vem_de_acompanhamento = params[:controller] == "acompanhamentos"
    @acompanhamento = vem_de_acompanhamento ? Acompanhamento.find(params[:id]) : Acompanhamento.find(params[:acompanhamento_id])
    # retorna se não for secretária que trabalha o dia inteiro comigo ou o profissional responsável
    if @acompanhamento.profissional != usuario_atual.profissional
      redirect_to acompanhamento_path(@acompanhamento), notice: "Não senhor!"
      return
    end
    semanas_pra_passar = 4 / @acompanhamento.num_sessoes

    au = @acompanhamento.atendimentos.em_ordem.last
    atendimento = @acompanhamento.atendimentos.new
    auvalor = au.atendimento_valor
    avalor = atendimento.build_atendimento_valor

    proxima_semana = (Date.today + semanas_pra_passar.week).all_week.map { |d| {d.wday => d} }
    proxima_data = proxima_semana[au.data_inicio_verdadeira.wday].values.first
    
    # atendimento.data = au.data + semanas_pra_passar.week
    atendimento.data = proxima_data
    atendimento.horario = au.horario
    atendimento.horario_fim = au.horario_fim
    atendimento.modalidade_id = au.modalidade_id
    atendimento.atendimento_local_id = au.atendimento_local_id
    atendimento.atendimento_tipo_id = au.atendimento_tipo_id
    avalor.valor = @acompanhamento.valor_sessao
    avalor.taxa_porcentagem_interna = auvalor.taxa_porcentagem_interna
    avalor.taxa_porcentagem_externa = auvalor.taxa_porcentagem_externa

    if atendimento.save!
      avalor.save!
      if vem_de_acompanhamento
        redirect_to @acompanhamento, notice: "Novo atendimento registrado"
      else
        redirect_to root, notive: "Atendimento registrado para #{@acompanhamento.tipo.upcase} de #{@acompanhamento.pessoa.nome_abreviado} em #{atendimento.data.strftime("%d/%m/%Y")} às #{atendimento.horario.strftime("%Hh%M")}"
      end
    else
      redirect_to @acompanhamento, notice: "Não deu certo"
    end
  end

  def new_atendimento
  end

  def declaracao
    hoje = Time.now.strftime("%Y-%m-%d")
    hoje_formatado = Time.now.strftime("%d/%m/%Y")
    nome_documento = "declaracao_#{@acompanhamento.tipo}_#{hoje}_#{@acompanhamento.pessoa.nome_completo.parameterize}"

    respond_to do |format|
      format.html
      format.md do
        response.headers['Content-Type'] = 'text/markdown'
        response.headers['Content-Disposition'] = "attachment; filename=#{nome_documento}.md"
      end
      format.pdf do
        pdf = AcompanhamentoDeclaracaoPdf.new(@acompanhamento)
        send_data pdf.render, filename: "#{nome_documento}.pdf", type: "application/pdf", disposition: :inline
      end
    end
  end

  def contrato
    if params[:contrato_modelo].presence
      @profissional_contrato_modelo = ProfissionalContratoModelo.find(params[:contrato_modelo])
      respond_to do |format|
        if hx_request?
          format.html { render partial: "contrato_individual", locals: {acompanhamento: @acompanhamento, profissional_contrato_modelo: @profissional_contrato_modelo} }
        else
          format.html { render :contrato_individual }
        end
        format.md do
          response.headers['Content-Type'] = 'text/markdown'
          response.headers['Content-Disposition'] = "attachment; filename=#{@profissional_contrato_modelo.titulo.parameterize}_#{@acompanhamento.paciente.nome_completo.parameterize}_#{@acompanhamento.data_inicio}.md"
          render :contrato_individual
        end
        format.pdf do
        end
      end
    end
  end

  def acompanhamento_reajustes
  end

  def financeiro
  end

  def recebimentos
  end

  def new_recebimento
    @recebimento = Recebimento.new(acompanhamento: @acompanhamento)
  end

  def atendimento_valores
    @de = params[:de]&.to_date || Date.today.beginning_of_month
    @ate = params[:ate]&.to_date || Date.today.end_of_month
    @atendimento_valores = @acompanhamento.atendimento_valores.do_periodo(@de..@ate)
  end

  private

  def set_acompanhamento
    @acompanhamento = Acompanhamento.find(params[:id])
  end

  def acompanhamento_params
    params.require(:acompanhamento).permit(:pessoa_id, :profissional_id, :plataforma_id, :motivo, :data_inicio, :data_final, :finalizacao_motivo_id, :valor_sessao_contrato, :num_sessoes_contrato, :valor_sessao, :num_sessoes, :acompanhamento_tipo_id, :menor_de_idade, :pessoa_responsavel_id, :sessoes_previstas, :suspenso, :hipotese_diagnostica, :objetivo, :prognostico)
  end

  def dados_atendimento_pdf at
    return "#{at.data.strftime('%d/%m/%Y')}\n#{(at.consideracoes || 'Sem considerações')}"
  end

  def validar_usuario
    if usuario_atual.nil? || !(usuario_atual.corpo_clinico || usuario_atual.secretaria?)
      render file: "#{Rails.root}/public/404.html", status: 403
      return
    end
  end

  def validar_edicao
    if !(usuario_atual.secretaria? || usuario_atual.profissional == @acompanhamento.profissional)
      render file: "#{Rails.root}/public/404.html", status: 403
      return
    end
  end
end
