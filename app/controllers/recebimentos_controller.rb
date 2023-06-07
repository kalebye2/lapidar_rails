class RecebimentosController < ApplicationController
  before_action :set_recebimento, only: %i[ show update edit delete recibo ]

  def index
    @recebimentos = Recebimento.all.order(data: :desc)
  end

  def show
  end

  def new
    @recebimento = Recebimento.new
  end

  def edit
  end

  def create
    @recebimento = Recebimento.new(recebimento_params)

    respond_to do |format|
      if @recebimento.save
        format.html { redirect_to recebimento_url(@recebimento), notice: "recebimento was successfully created." }
        format.json { render :show, status: :created, location: @recebimento }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @recebimento.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @recebimento.update(recebimento_params)
        format.html { redirect_to recebimento_url(@recebimento), notice: "recebimento was successfully updated." }
        format.json { render :show, status: :ok, location: @recebimento }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @recebimento.errors, status: :unprocessable_entity }
      end
    end
  end

  def delete
  end

  def recibo
    hoje = Time.now.strftime("%Y-%m-%d")
    hoje_formatado = Time.now.strftime("%d/%m/%Y")
    nome_documento = "Recibo_#{hoje}"
  end

  private

  def set_recebimento
    @recebimento = Recebimento.find(params[:id])
  end

  def recebimento_params
    params.require(:recebimento).permit(:pessoa_pagante_id, :acompanhamento_id, :valor, :data, :modalidade_id)
  end
end