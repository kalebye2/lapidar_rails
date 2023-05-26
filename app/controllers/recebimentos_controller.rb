class RecebimentosController < ApplicationController
  before_action :set_recebimento, only: %i[ show update delete ]

  def index
    @recebimentos = Recebimento.all.order(data: :desc)
  end

  def show
  end

  def new
  end

  def create
  end

  def update
  end

  def delete
  end

  private

  def set_recebimento
    @recebimento = Recebimento.find(params[:id])
  end
end
