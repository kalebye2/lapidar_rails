class AcompanhamentoTiposController < ApplicationController
  before_action :set_acompanhamento_tipo, only: %i[ show edit update destroy ]
  before_action :validar_usuario

  def index
    @acompanhamento_tipos = AcompanhamentoTipo.all
  end

  def show
  end

  def new
    @acompanhamento_tipo = AcompanhamentoTipo.new
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

  def set_acompanhamento_tipo
    @acompanhamento_tipo = AcompanhamentoTipo.find(params[:id])
  end
end
