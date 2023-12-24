class PessoaDevolutivasController < ApplicationController
  before_action :set_pessoa_devolutiva, only: %i[ show edit update destroy ]

  # GET /pessoa_devolutivas or /pessoa_devolutivas.json
  def index
    @pessoa_devolutivas = PessoaDevolutiva.cronologico
  end

  # GET /pessoa_devolutivas/1 or /pessoa_devolutivas/1.json
  def show
    respond_to do |format|
      format.html
      format.md do
        response.headers["Content-Type"] = "text/markdown"
        response.headers["Content-Disposition"] = "attachment; filename=devolutiva_#{@pessoa_devolutiva.pessoa.nome_completo.parameterize}_#{@pessoa_devolutiva.data}.md"
      end
    end
  end

  # GET /pessoa_devolutivas/new
  def new
    @pessoa_devolutiva = PessoaDevolutiva.new
  end

  # GET /pessoa_devolutivas/1/edit
  def edit
  end

  # POST /pessoa_devolutivas or /pessoa_devolutivas.json
  def create
    @pessoa_devolutiva = PessoaDevolutiva.new(pessoa_devolutiva_params)

    respond_to do |format|
      if @pessoa_devolutiva.save
        format.html { redirect_to devolutiva_url(@pessoa_devolutiva), notice: "pessoa devolutiva was successfully created." }
        format.json { render :show, status: :created, location: @pessoa_devolutiva }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pessoa_devolutiva.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pessoa_devolutivas/1 or /pessoa_devolutivas/1.json
  def update
    respond_to do |format|
      if @pessoa_devolutiva.update(pessoa_devolutiva_params)
        if params[:ajax].present?
          format.html { render :show }
        else
          format.html { redirect_to devolutiva_url(@pessoa_devolutiva), notice: "pessoa devolutiva was successfully updated." }
          format.json { render :show, status: :ok, location: @pessoa_devolutiva }
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pessoa_devolutiva.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pessoa_devolutivas/1 or /pessoa_devolutivas/1.json
  def destroy
    @pessoa_devolutiva.destroy

    respond_to do |format|
      format.html { redirect_to pessoa_devolutivas_url, notice: "pessoa devolutiva was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pessoa_devolutiva
      @pessoa_devolutiva = PessoaDevolutiva.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pessoa_devolutiva_params
      params.require(:pessoa_devolutiva).permit(:pessoa_id, :pessoa_responsavel_id, :profissional_id, :data, :feedback_responsavel, :orientacoes_profissional, :pontos_a_abordar)
    end
end
