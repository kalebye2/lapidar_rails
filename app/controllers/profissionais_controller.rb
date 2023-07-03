class ProfissionaisController < ApplicationController
  before_action :set_profissional, only: %i[ show edit update delete acompanhamentos ]

  def index
    @profissionais = params[:q].present? ? Profissional.joins(:pessoa).where("CONCAT(nome, ' ', COALESCE(nome_do_meio, ''), ' ', sobrenome) LIKE ?", "%#{params[:q]}%") : Profissional.all.joins("JOIN pessoas ON profissionais.pessoa_id = pessoas.id").order(nome: :asc, sobrenome: :asc)
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
  end

  def update
    respond_to do |format|
      if @profissional.update(profissional_params)
        format.html { redirect_to profissional_url(@profissional), notice: "Profissional atualizado com sucesso!" }
        format.json { render :show, status: :ok, location: @profissional }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render :json, @profissional.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  end

  def acompanhamentos
    @acompanhamentos = @profissional.acompanhamentos
  end

  private

  def set_profissional
    @profissional = Profissional.find(params[:id])
  end

  def profissional_params
    params.require(:profissional).permit(:pessoa_id, :profissional_funcao_id, :documento_regiao_id, :documento_valor, :chave_pix_01, :chave_pix_02, :bio)
  end
end
