class UsuarioExtraInformacoesController < ApplicationController
  before_action :set_usuario_extra_informacao, only: %i[ show show_pdf edit update delete ]

  def index
    @usuario_extra_informacoes = UsuarioExtraInformacao.all
  end

  def new
    @usuario_extra_informacao = UsuarioExtraInformacao.new
  end

  def create
    @usuario_extra_informacao = UsuarioExtraInformacao.new(usuario_extra_informacao_params)
    respond_to do |format|
      if @usuario_extra_informacao.save
        format.html { redirect_to usuario_extra_informacoes_url(@usuario_extra_informacao), notice: "Informação extra adicionada!" }
        format.json { render :show, status: :created, location: @usuario_extra_informacao }
      else
        format.html { render :new, status: :unprocessable_identity }
        format.json { render json: @usuario_extra_informacao.errors, status: :unprocessable_identity }
      end
    end
  end

  def show
  end

  def show_pdf
    return 0
  end

  def edit
  end

  def update
    respond_to do |format|
      if @usuario_extra_informacao.update(usuario_extra_informacao_params)
        format.html { redirect_to usuario_extra_informacao_url(@usuario_extra_informacao), notice: "Informação extra atualizada." }
        format.json { render :show, status: :ok, location: @usuario_extra_informacao }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @usuario_extra_informacao.errors, status: :unprocessable_entity }
      end
    end
  end

  def delete
  end

  private

  def set_usuario_extra_informacao
    @usuario_extra_informacao = UsuarioExtraInformacao.find(params[:id])
  end

  def usuario_extra_informacao_params
    params.require(:usuario_extra_informacao).permit(:usuario_id, :data, :conteudo_material, :meio)
  end
end
