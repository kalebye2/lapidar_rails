class ProfissionalFuncoesController < ApplicationController
  before_action :set_profissional_funcao, only: %i[ show edit update destroy ]
  before_action :validar_usuario

  def index
    @profissional_funcoes = ProfissionalFuncao.all
  end

  def show
    respond_to do |format|
      format.html do
        if hx_request?
          render partial: "profissional_funcao_tabela", locals: {profissional_funcao: @profissional_funcao}
          return
        end
      end
    end
  end

  def new
    @profissional_funcao = ProfissionalFuncao.new
  end

  def create
    @profissional_funcao = ProfissionalFuncao.new(profissional_funcao_params)
    if !(usuario_atual.admin?)
      erro403
      return
    end

    respond_to do |format|
      if @profissional_funcao.save
        format.html do
          if hx_request?
            index
            return
          else
            index
            return
          end
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @recebimento.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @hx_params = params.permit(:de, :ate, :pessoa, :pagante, :modalidade, :profissional)
    @params = params.permit(:profissional_funcao)
    if hx_request?
      render partial: "form-tabela", locals: {profissional_funcao: @profissional_funcao}
      return
    end
  end

  def update
    if !usuario_atual.admin?
      erro403
      return
    end

    respond_to do |format|
      if @profissional_funcao.update(profissional_funcao_params)
        format.html do
          if hx_request?
            render partial: "profissional_funcao_tabela", locals: {profissional_funcao: @profissional_funcao}
          end
        end
      else
      end
    end
  end

  def destroy
  end
  
  private

  def profissional_funcao_params
    params.require(:profissional_funcao).permit %i[funcao orgao_responsavel documento_tipo flexao_feminino, servico adjetivo_masc adjetivo_fem realiza_atendimentos]
  end

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
