class PessoaFinanceiroRepassesController < ApplicationController

  private
  def pessoa_financeiro_repasses_controller_params
    params.require(:pessoa_financeiro_repasses).permit(:data, :profissional_id, :valor, :modalidade_id)
  end
end
