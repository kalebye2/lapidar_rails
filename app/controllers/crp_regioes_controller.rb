class CrpRegioesController < ApplicationController
  before_action :set_crp_regiao, only: %i[ show edit update destroy ]

  # GET /crp_regioes or /crp_regioes.json
  def index
    @crp_regioes = CrpRegiao.all
  end

  # GET /crp_regioes/1 or /crp_regioes/1.json
  def show
  end

  # GET /crp_regioes/new
  def new
    @crp_regiao = CrpRegiao.new
  end

  # GET /crp_regioes/1/edit
  def edit
  end

  # POST /crp_regioes or /crp_regioes.json
  def create
    @crp_regiao = CrpRegiao.new(crp_regiao_params)

    respond_to do |format|
      if @crp_regiao.save
        format.html { redirect_to crp_regiao_url(@crp_regiao), notice: "Crp regiao was successfully created." }
        format.json { render :show, status: :created, location: @crp_regiao }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @crp_regiao.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /crp_regioes/1 or /crp_regioes/1.json
  def update
    respond_to do |format|
      if @crp_regiao.update(crp_regiao_params)
        format.html { redirect_to crp_regiao_url(@crp_regiao), notice: "Crp regiao was successfully updated." }
        format.json { render :show, status: :ok, location: @crp_regiao }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @crp_regiao.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /crp_regioes/1 or /crp_regioes/1.json
  def destroy
    @crp_regiao.destroy

    respond_to do |format|
      format.html { redirect_to crp_regioes_url, notice: "Crp regiao was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_crp_regiao
      @crp_regiao = CrpRegiao.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def crp_regiao_params
      params.require(:crp_regiao).permit(:uf_id)
    end
end
