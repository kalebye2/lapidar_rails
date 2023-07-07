class AtendimentosController < ApplicationController
  before_action :set_atendimento, only: %i[ show edit update destroy reagendar_para_proxima_semana gerar_atendimento_valor ]
  before_action :validar_usuario
  before_action :validar_edicao, only: %i[ show edit update destroy reagendar_para_proxima_semana gerar_atendimento_valor ]

  def index
  end

  def show
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
        valor = @atendimento.build_atendimento_valor
        valor.taxa_porcentagem_externa = @atendimento.acompanhamento.atendimentos.last.valor_atendimento.taxa_porcentagem_externa
        valor.taxa_porcentagem_interna = @atendimento.acompanhamento.atendimentos.last.valor_atendimento.taxa_porcentagem_interna
        valor.valor = @atendimento.acompanhamento.valor_atual
        valor.save
        format.html { redirect_to atendimento_url(@atendimento), notice: "Atendimento registrado com sucesso!" }
        format.json { render :show, status: :created, location: @atendimento }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @atendimento.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @atendimento.update(atendimento_params)
        format.html { redirect_to atendimento_url(@atendimento), notice: "Atendimento atualizado com sucesso." }
        format.json { render :show, status: :ok, location: @atendimento }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @atendimento.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
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
      if @atendimento.update(data: @atendimento.data + 7.day, reagendado: true)
        format.html { redirect_to atendimento_url(@atendimento), notice: "Atendimento agendado para a semana seguinte" }
        format.json { render :show, status: :ok, location: @atendimento }
      else
        format.html { render :show, status: :unprocessable_entity }
        format.json { render json: @atendimento.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_atendimento
    @atendimento = Atendimento.find(params[:id])
  end

  def atendimento_params
    params.require(:atendimento).permit(:data, :horario, :modalidade_id, :acompanhamento_id, :presenca, :atendimento_tipo_id, :consideracoes, :remarcado, :atendimento_local_id, :reagendado, atendimento_valor_attributes: [:atendimento_id, :valor, :desconto, :taxa_porcentagem_externa, :taxa_porcentagem_interna, :id])
  end

  def validar_usuario
    if usuario_atual.nil? || !(usuario_atual.corpo_clinico? || usuario_atual.secretaria?)
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
