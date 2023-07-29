class BibliotecaObrasController < ApplicationController
  before_action :set_obra, only: %i[ show edit destroy ]

  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  private

  def set_obra
    @obra = BibliotecaObra.find(params[:id])
  end

  def obra_params
    params.require(:obra).permit(:titulo, :subtitulo, :obra_tipo_id, :editora_id, :ordem, :data_publicacao, :isbn, :caminho, :obra_virtual, :num_paginas, :resumo, :edicao, :volume, :periodico_id)
  end
end
