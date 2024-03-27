class PessoaMedicacoesController < ApplicationController
  before_action :set_pessoa_medicacao, only: %i[ show edit update destroy ]

  # GET /pessoa_medicacoes or /pessoa_medicacoes.json
  def index
    @pessoa_medicacoes = PessoaMedicacao.all
  end

  # GET /pessoa_medicacoes/1 or /pessoa_medicacoes/1.json
  def show
  end

  # GET /pessoa_medicacoes/new
  def new
    @pessoa_medicacao = PessoaMedicacao.new
  end

  # GET /pessoa_medicacoes/1/edit
  def edit
  end

  # POST /pessoa_medicacoes or /pessoa_medicacoes.json
  def create
    @pessoa_medicacao = PessoaMedicacao.new(pessoa_medicacao_params)

    respond_to do |format|
      if @pessoa_medicacao.save
        format.html { redirect_to pessoa_medicacao_url(@pessoa_medicacao), notice: "Pessoa medicacao was successfully created." }
        format.json { render :show, status: :created, location: @pessoa_medicacao }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pessoa_medicacao.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pessoa_medicacoes/1 or /pessoa_medicacoes/1.json
  def update
    respond_to do |format|
      if @pessoa_medicacao.update(pessoa_medicacao_params)
        format.html { redirect_to pessoa_medicacao_url(@pessoa_medicacao), notice: "Pessoa medicacao was successfully updated." }
        format.json { render :show, status: :ok, location: @pessoa_medicacao }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pessoa_medicacao.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pessoa_medicacoes/1 or /pessoa_medicacoes/1.json
  def destroy
    @pessoa_medicacao.destroy

    respond_to do |format|
      format.html { redirect_to pessoa_medicacoes_url, notice: "Pessoa medicacao was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pessoa_medicacao
      @pessoa_medicacao = PessoaMedicacao.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pessoa_medicacao_params
      params.require(:pessoa_medicacao).permit(:pessoa_id, :medicacao, :dose, :motivo, :data_inicio, :data_final)
    end
end
