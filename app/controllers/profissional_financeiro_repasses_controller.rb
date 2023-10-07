class ProfissionalFinanceiroRepassesController < ApplicationController

  def index
    @repasses = ProfissionalFinanceiroRepasse.all
  end

  def show
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end

  private
  def set_profissional_financeiro_repasse
    @repasse = ProfissionalFinanceiroRepasse.find_by(params[:id])
  end

  def profissional_financeiro_repasses_params
    params.require(:profissional_financeiro_repasses).permit(:data, :profissional_id, :valor, :modalidade_id)
  end
end
