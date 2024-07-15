class BibliotecaAutoresController < ApplicationController
  before_action :set_biblioteca_autor, only: %i[ show edit update destroy ]

  # GET /biblioteca_autores or /biblioteca_autores.json
  def index
    @biblioteca_autores = BibliotecaAutor.all
  end

  # GET /biblioteca_autores/1 or /biblioteca_autores/1.json
  def show
  end

  # GET /biblioteca_autores/new
  def new
    @biblioteca_autor = BibliotecaAutor.new
  end

  # GET /biblioteca_autores/1/edit
  def edit
  end

  # POST /biblioteca_autores or /biblioteca_autores.json
  def create
    @biblioteca_autor = BibliotecaAutor.new(biblioteca_autor_params)

    respond_to do |format|
      if @biblioteca_autor.save
        format.html { redirect_to biblioteca_autor_url(@biblioteca_autor), notice: "Biblioteca autor was successfully created." }
        format.json { render :show, status: :created, location: @biblioteca_autor }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @biblioteca_autor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /biblioteca_autores/1 or /biblioteca_autores/1.json
  def update
    respond_to do |format|
      if @biblioteca_autor.update(biblioteca_autor_params)
        format.html { redirect_to biblioteca_autor_url(@biblioteca_autor), notice: "Biblioteca autor was successfully updated." }
        format.json { render :show, status: :ok, location: @biblioteca_autor }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @biblioteca_autor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /biblioteca_autores/1 or /biblioteca_autores/1.json
  def destroy
    @biblioteca_autor.destroy

    respond_to do |format|
      format.html { redirect_to biblioteca_autores_url, notice: "Biblioteca autor was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_biblioteca_autor
      @biblioteca_autor = BibliotecaAutor.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def biblioteca_autor_params
      params.require(:biblioteca_autor).permit(:nome, :nome_do_meio, :sobrenome, :ordem, :feminino, :link, :bio)
    end
end
