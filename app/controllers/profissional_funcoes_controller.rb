class ProfissionalFuncoesController < ApplicationController
  before_action :set_profissional_funcao, only: %i[ show edit update destroy ]
  before_action :validar_usuario

  def index
    @profissional_funcoes = ProfissionalFuncao.all
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
  
  private

  def validar_usuario
    if !usuario_logado || !checar(usuario_atual.informatica?)
      erro403
      return
    end
  end
  
  def set_profissional_funcao
    @profissional_funcao = ProfissionalFuncao.find(params[:id])
  end
end
