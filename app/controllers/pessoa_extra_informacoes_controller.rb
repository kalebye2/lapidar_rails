class PessoaExtraInformacoesController < ApplicationController
  before_action :set_pessoa_extra_informacao, only: %i[ show show_pdf edit update delete ]

  def index
    @pessoa_extra_informacoes = PessoaExtraInformacao.all
  end

  def new
    @pessoa_extra_informacao = PessoaExtraInformacao.new
  end

  def create
    @pessoa_extra_informacao = PessoaExtraInformacao.new(pessoa_extra_informacao_params)
    respond_to do |format|
      if @pessoa_extra_informacao.save
        pessoa_id = @pessoa_extra_informacao.pessoa_id
        format.html { redirect_to "/cadastros/#{pessoa_id}/informacoes_extras", notice: "Informação extra adicionada!" }
        format.json { render :show, status: :created, location: @pessoa_extra_informacao }
      else
        format.html { render :new, status: :unprocessable_identity }
        format.json { render json: @pessoa_extra_informacao.errors, status: :unprocessable_identity }
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
      if @pessoa_extra_informacao.update(pessoa_extra_informacao_params)
        pessoa_id = @pessoa_extra_informacao.pessoa_id
        format.html { redirect_to "/cadastros/#{pessoa_id}/informacoes_extras", notice: "Informação extra atualizada." }
        format.json { render :show, status: :ok, location: @pessoa_extra_informacao }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pessoa_extra_informacao.errors, status: :unprocessable_entity }
      end
    end
  end

  def delete
  end

  private

  def set_pessoa_extra_informacao
    @pessoa_extra_informacao = PessoaExtraInformacao.find(params[:id])
  end

  def pessoa_extra_informacao_params
    params.require(:pessoa_extra_informacao).permit(:pessoa_id, :data, :conteudo_material, :meio)
  end
end
