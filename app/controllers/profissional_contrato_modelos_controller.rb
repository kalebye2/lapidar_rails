class ProfissionalContratoModelosController < ApplicationController
  before_action :set_profissional_contrato_modelo, only: %i[ show edit update destroy ]
  before_action :validar_usuario

  def index
    @profissionais = Profissional.all

    if !usuario_atual.secretaria? && usuario_atual.corpo_clinico?
      redirect_to contrato_modelos_profissional_url(usuario_atual.profissional)
    end
  end

  def show
    respond_to do |format|
      format.html do
        if hx_request?
          render partial: "contrato_modelo_documento", locals: { profissional_contrato_modelo: @profissional_contrato_modelo }
        end
      end
    end
  end

  def new
    @profissional_contrato_modelo = ProfissionalContratoModelo.new(profissional: @profissional)
  end

  def create
    if !(usuario_atual.secretaria? || usuario_atual.profissional == @profissional_contrato_modelo.profissional)
      render html: "Proibido", status: :forbidden
      return
    end
    @profissional_contrato_modelo = ProfissionalContratoModelo.new(profissional_contrato_modelo_params)

    respond_to do |format|
      if @profissional_contrato_modelo.save
        format.html { redirect_to profissional_contrato_modelo_url(@profissional_contrato_modelo), notice: "Modelo criado com sucesso!" }
        format.json { render :show, status: :created, location: @profissional_contrato_modelo }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @profissional_contrato_modelo.update(profissional_contrato_modelo_params)
        format.html { redirect_to profissional_contrato_modelo_url(@profissional_contrato_modelo), notice: "Modelo de contrato atualizado com sucesso!" }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @profissional_contrato_modelo.destroy

    respond_to do |format|
      format.html { redirect_to profissional_contrato_modelos_url, notice: "Modelo de contrato excluído com sucesso." }
      format.json { head :no_content }
    end
  end

  private

  def validar_usuario
    if usuario_atual.nil? || !(usuario_atual.secretaria? || usuario_atual.corpo_clinico?)
      erro403
      return
    end
  end

  def set_profissional_contrato_modelo
    @profissional_contrato_modelo = ProfissionalContratoModelo.find(params[:id])
  end

  def profissional_contrato_modelo_params
    params.require(:profissional_contrato_modelo).permit(%i[ profissional_id titulo descricao conteudo ])
  end
end
