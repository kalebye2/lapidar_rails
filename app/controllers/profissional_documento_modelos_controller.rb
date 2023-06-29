class ProfissionalDocumentoModelosController < ApplicationController
  before_action :set_profissional_documento_modelo, only: %i[ show edit update destroy ]

  def index
    @profissional_documento_modelos = ProfissionalDocumentoModelo.all
  end

  def show
  end

  def new
  end

  def create
    @profissional_documento_modelo = profissional_documento_modelo.new(profissional_documento_modelo_params)

    respond_to do |format|
      if @profissional_documento_modelo.save
        format.html { redirect_to profissional_documento_modelo_url(@profissional_documento_modelo), notice: "profissional_documento_modelo was successfully created." }
        format.json { render :show, status: :created, location: @profissional_documento_modelo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @profissional_documento_modelo.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    params["profissional_documento_modelo"]["cpf"] = params["profissional_documento_modelo"]["cpf"].gsub(/\D/, '')[-11..]
    respond_to do |format|
      if @profissional_documento_modelo.update(profissional_documento_modelo_params)
        format.html { redirect_to profissional_documento_modelo_url(@profissional_documento_modelo), notice: "profissional_documento_modelo was successfully updated." }
        format.json { render :show, status: :ok, location: @profissional_documento_modelo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @profissional_documento_modelo.errors, status: :unprocessable_entity }
      end
    end
  end

  def delete
  end

  private

  def set_profissional_documento_modelo
    @profissional_documento_modelo = ProfissionalDocumentoModelo.find(params[:id])
    # só pra ficar legal
    @documento_sub = {
      "acompanhamento": {
       '#{profissional}' => "profissional_nome",
       '#{paciente}' => "b",
       '#{valor_contrato}' => "20",
      },
      "atendimento": {
      },
    }
  end

  def profissional_documento_modelo_params
    params.require(:profissional_documento_modelo).permit(:profissional_id, :titulo, :descricao, :conteudo)
  end
end
