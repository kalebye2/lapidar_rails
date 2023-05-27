class ProfissionaisController < ApplicationController
  before_action :set_profissional, only: %i[ show edit update delete ]

  def index
    @profissionais = Profissional.all.joins("JOIN pessoas ON profissionais.pessoa_id = pessoas.id").order(nome: :asc, sobrenome: :asc)
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end


  private

  def set_profissional
    @profissional = Profissional.find(params[:id])
  end
end
