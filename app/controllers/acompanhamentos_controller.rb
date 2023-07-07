class AcompanhamentosController < ApplicationController
  before_action :set_acompanhamento, only: %i[ show edit update destroy caso_detalhes ]
  before_action :validar_usuario
  before_action :validar_edicao, only: %i[ edit update destroy ]

  def index
    if !usuario_atual.secretaria?
      @acompanhamentos = usuario_atual.profissional.acompanhamentos.all.order(data_inicio: :desc)
    else
      @acompanhamentos = Acompanhamento.all.order(data_inicio: :desc)
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
    end
  end

  def new
    @acompanhamento = Acompanhamento.new
  end

  def edit
  end

  def create
    @acompanhamento = Acompanhamento.new(acompanhamento_params)
    # colocar as informações no sistema
    @acompanhamento.sessoes_atuais = @acompanhamento.sessoes_contrato
    @acompanhamento.valor_atual = @acompanhamento.valor_contrato

    respond_to do |format|
      if @acompanhamento.save
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
      if @acompanhamento.update(acompanhamento_params)
        format.html { redirect_to acompanhamento_url(@acompanhamento), notice: "acompanhamento was successfully updated." }
        format.json { render :show, status: :ok, location: @acompanhamento }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @acompanhamento.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  end


  def caso_detalhes
    respond_to do |format|
      format.html

      format.pdf do
        hoje = Time.now.strftime("%Y-%m-%d")
        hoje_formatado = Time.now.strftime("%d/%m/%Y")
        nome_documento = "#{@acompanhamento.pessoa.nome_completo}_caso-detalhes_#{hoje}"

        pdf = Prawn::Document.new
        pdf.text "#{@acompanhamento.pessoa.nome_completo} - Detalhes do caso"
        pdf.text "Documento gerado em " + (hoje_formatado)

        pdf.stroke_horizontal_rule
        pdf.move_down 20
        # atendimentos
        @acompanhamento.atendimentos.where.not(consideracoes: nil).each do |at|
          pdf.text (dados_atendimento_pdf at)
          pdf.stroke_horizontal_rule
          pdf.move_down 10
        end

        send_data(pdf.render,
                  filename: "#{nome_documento}.pdf",
                  type: "application/pdf",
                  disposition: "inline"
                 )
      end

    end
  end

  def new_atendimento_proxima_semana
    @acompanhamento = Acompanhamento.find(params[:acompanhamento_id])
    # retorna se não for secretária que trabalha o dia inteiro comigo ou o profissional responsável
    if @acompanhamento.profissional != usuario_atual.profissional
      redirect_to acompanhamento_path(@acompanhamento), notice: "Não senhor!"
      return
    end
    semanas_pra_passar = 4 / @acompanhamento.sessoes_atuais

    au = @acompanhamento.atendimentos.last
    atendimento = @acompanhamento.atendimentos.new
    auvalor = au.atendimento_valor
    avalor = atendimento.build_atendimento_valor
    atendimento.data = au.data + semanas_pra_passar.week
    atendimento.horario = au.horario
    atendimento.modalidade_id = au.modalidade_id
    atendimento.atendimento_local_id = au.atendimento_local_id
    atendimento.atendimento_tipo_id = au.atendimento_tipo_id
    avalor.valor = @acompanhamento.valor_atual
    avalor.taxa_porcentagem_interna = auvalor.taxa_porcentagem_interna
    avalor.taxa_porcentagem_externa = auvalor.taxa_porcentagem_externa

    atendimento.save!
    avalor.save!
    #atendimento = @acompanhamento.atendimento.create(data: au.data + 7.day, horario: au.horario, modalidade_id: au.modalidade_id, atendimento_local_id: au.atendimento_local_id, atendimento_tipo_id: au.atendimento_tipo_id)
    redirect_to @acompanhamento, notice: "Novo atendimento registrado"
  end

  private

  def set_acompanhamento
=begin
    if usuario_atual.secretaria?
      @acompanhamento = Acompanhamento.find(params[:id])
    else
      begin
      @acompanhamento = usuario_atual.profissional.acompanhamentos.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        @acompanhamento = nil
        render file: "#{Rails.root}/public/404.html", status: 403
        return
      end
    end
=end
    @acompanhamento = Acompanhamento.find(params[:id])
  end

  def acompanhamento_params
    params.require(:acompanhamento).permit(:pessoa_id, :profissional_id, :plataforma_id, :motivo, :data_inicio, :data_final, :finalizacao_motivo_id, :valor_contrato, :sessoes_contrato, :valor_atual, :sessoes_atuais, :acompanhamento_tipo_id, :menor_de_idade, :pessoa_responsavel_id, :sessoes_previstas)
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
