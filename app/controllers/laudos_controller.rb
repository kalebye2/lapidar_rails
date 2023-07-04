class LaudosController < ApplicationController
  before_action :set_laudo, only: %i[ show edit update delete ]
  def index
    @laudos = Laudo.order(data_avaliacao: :desc)
  end

  def show
    respond_to do |format|
      format.md
      format.html
    end
  end

  def new
    @laudo = Laudo.new
  end

  def create
    @laudo = Laudo.new(laudo_params)

    respond_to do |format|
      if @laudo.save
        format.html { redirect_to laudo_url(@laudo), notice: "laudo was successfully created." }
        format.json { render :show, status: :created, location: @laudo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @laudo.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @laudo.update(laudo_params)
        format.html { redirect_to laudo_url(@laudo), notice: "laudo was successfully updated." }
        format.json { render :show, status: :ok, location: @laudo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @laudo.errors, status: :unprocessable_entity }
      end
    end
  end

  def delete
  end


  private

  def set_laudo
    @laudo = Laudo.find(params[:id])
  end

  def laudo_params
    params.require(:laudo).permit(:acompanhamento_id, :interessado, :data_avaliacao, :finalidade, :demanda, :tecnicas, :analise, :conclusao)
  end
end
