class ProfissionaisController < ApplicationController
  before_action :set_profissional, only: %i[ show edit update delete ]

  def index
    @profissionais = Profissional.all
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
