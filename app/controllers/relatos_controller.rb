class RelatosController < ApplicationController
  before_action :set_relato, only: %i[ show edit update destroy ]

  def index
    @relatos = Relato.all.order(id: :desc)
  end

  def show
  end

  def new
    @relato = Relato.new
  end

  def edit
  end

  def create
    @relato = Relato.new(relato_params)

    respond_to do |format|
      if @relato.save
        format.html { redirect_to relato_url(@relato), notice: "Relato registrado." }
        format.json { render :show, status: :created, location: @relato }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @relato.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
  end

  def destroy
  end


  private

  def set_relato
    @relato = Relato.find(params[:id])
  end

  def relato_params
    params.require(:relato).permit(:id, :relato)
  end

end
