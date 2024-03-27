class AcompanhamentoReajustesController < ApplicationController
  before_action :set_acompanhamento_reajuste, only: %i[ show edit update destroy fazer_ajuste aplicar_ajuste ]
  before_action :validar_usuario
  before_action :validar_usuario_para_acompanhamento_reajuste, only: %i[ fazer_ajuste aplicar_ajuste ]

  include Pagy::Backend

  # GET /acompanhamento_reajustes or /acompanhamento_reajustes.json
  def index
    @ajuste_de = params[:ajuste_de]&.to_date || AcompanhamentoReajuste.minimum(:data_ajuste)
    @negociacao_de = params[:negociacao_de]&.to_date || AcompanhamentoReajuste.minimum(:data_negociacao)
    @ajuste_ate = params[:ajuste_ate]&.to_date || AcompanhamentoReajuste.maximum(:data_ajuste)
    @negociacao_ate = params[:negociacao_ate]&.to_date || AcompanhamentoReajuste.maximum(:data_negociacao)

    if usuario_atual.financeiro?
      @acompanhamento_reajustes = AcompanhamentoReajuste.all
    else
      @acompanhamento_reajustes = usuario_atual.profissional.acompanhamento_reajustes
    end

    @acompanhamento_reajustes = @acompanhamento_reajustes.ajustes_no_periodo(@ajuste_de..@ajuste_ate)
    @acompanhamento_reajustes = @acompanhamento_reajustes.negociacoes_no_periodo(@negociacao_de..@negociacao_ate)
    @contagem = @acompanhamento_reajustes.count
    @pagy, @acompanhamento_reajustes = pagy(@acompanhamento_reajustes, items: 9)
    @params = params.permit(:ajuste_de, :ajuste_ate, :negociacao_de, :negociacao_ate)

    if hx_request?
      render partial: "acompanhamento_reajustes/acompanhamento_reajustes-container", locals: { acompanhamento_reajustes: @acompanhamento_reajustes }
    end
  end

  # GET /acompanhamento_reajustes/1 or /acompanhamento_reajustes/1.json
  def show
  end

  # GET /acompanhamento_reajustes/new
  def new
    @acompanhamento_reajuste = AcompanhamentoReajuste.new
  end

  # GET /acompanhamento_reajustes/1/edit
  def edit
  end

  # POST /acompanhamento_reajustes or /acompanhamento_reajustes.json
  def create
    @acompanhamento_reajuste = AcompanhamentoReajuste.new(acompanhamento_reajuste_params)

    respond_to do |format|
      if @acompanhamento_reajuste.save
        format.html { redirect_to acompanhamento_reajuste_url(@acompanhamento_reajuste), notice: "Acompanhamento reajuste was successfully created." }
        format.json { render :show, status: :created, location: @acompanhamento_reajuste }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @acompanhamento_reajuste.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /acompanhamento_reajustes/1 or /acompanhamento_reajustes/1.json
  def update
    respond_to do |format|
      if @acompanhamento_reajuste.update(acompanhamento_reajuste_params)
        format.html { redirect_to acompanhamento_reajuste_url(@acompanhamento_reajuste), notice: "Acompanhamento reajuste was successfully updated." }
        format.json { render :show, status: :ok, location: @acompanhamento_reajuste }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @acompanhamento_reajuste.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /acompanhamento_reajustes/1 or /acompanhamento_reajustes/1.json
  def destroy
    @acompanhamento_reajuste.destroy

    respond_to do |format|
      format.html { redirect_to acompanhamento_reajustes_url, notice: "Acompanhamento reajuste was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def fazer_ajuste
    if @acompanhamento_reajuste.acompanhamento.update(acompanhamento_reajuste_params[:acompanhamento])
      redirect_to @acompanhamento_reajuste.acompanhamento
    else
    end
  end

  def aplicar_ajuste
    if @acompanhamento_reajuste.acompanhamento.update(valor_sessao: @acompanhamento_reajuste.valor_novo)
      if hx_request?
        render html: "Ajuste aplicado!"
      else
      end
    else
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_acompanhamento_reajuste
      @acompanhamento_reajuste = AcompanhamentoReajuste.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def acompanhamento_reajuste_params
      params.require(:acompanhamento_reajuste).permit(:acompanhamento_id, :data_ajuste, :valor_novo, :data_negociacao, :acompanhamento_reajuste_motivo_id, acompanhamento: %i[ valor_sessao ])
    end

    # Permitir que informações só sejam compartilhadas quando houver autenticação
    def validar_usuario
      if !checar usuario_logado, usuario_atual.secretaria?, usuario_atual.profissional == @acompanhamento_reajuste&.profissional
        erro403
        return
      end
    end

    def validar_usuario_para_acompanhamento_reajuste
      if usuario_atual.profissional != @acompanhamento_reajuste.profissional
        erro403
      end
    end
end
