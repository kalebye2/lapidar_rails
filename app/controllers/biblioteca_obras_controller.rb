class BibliotecaObrasController < ApplicationController
  before_action :set_biblioteca_obra, only: %i[ show edit update destroy ]

  # GET /biblioteca_obras or /biblioteca_obras.json
  def index
    @biblioteca_obras = BibliotecaObra.all
  end

  # GET /biblioteca_obras/1 or /biblioteca_obras/1.json
  def show
  end

  # GET /biblioteca_obras/new
  def new
    @biblioteca_obra = BibliotecaObra.new
  end

  # GET /biblioteca_obras/1/edit
  def edit
  end

  # POST /biblioteca_obras or /biblioteca_obras.json
  def create
    @biblioteca_obra = BibliotecaObra.new(biblioteca_obra_params)

    respond_to do |format|
      if @biblioteca_obra.save
        format.html { redirect_to biblioteca_obra_url(@biblioteca_obra), notice: "Biblioteca obra was successfully created." }
        format.json { render :show, status: :created, location: @biblioteca_obra }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @biblioteca_obra.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /biblioteca_obras/1 or /biblioteca_obras/1.json
  def update
    respond_to do |format|
      if @biblioteca_obra.update(biblioteca_obra_params)
        format.html { redirect_to biblioteca_obra_url(@biblioteca_obra), notice: "Biblioteca obra was successfully updated." }
        format.json { render :show, status: :ok, location: @biblioteca_obra }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @biblioteca_obra.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /biblioteca_obras/1 or /biblioteca_obras/1.json
  def destroy
    @biblioteca_obra.destroy

    respond_to do |format|
      format.html { redirect_to biblioteca_obras_url, notice: "Biblioteca obra was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_biblioteca_obra
      @biblioteca_obra = BibliotecaObra.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def biblioteca_obra_params
      params.require(:biblioteca_obra).permit(:titulo, :subtitulo, :biblioteca_obra_tipo_id, :biblioteca_editora_id, :ordem, :data_publicacao, :isbn, :caminho, :obra_virtual, :num_paginas, :resumo, :edicao, :volume, :periodico_id)
    end
end
