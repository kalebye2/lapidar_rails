class BibliotecaController < ApplicationController
  def index
    @obras = BibliotecaObra.order(titulo: :asc, subtitulo: :asc)
  end
end
