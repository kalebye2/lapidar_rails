class RecebimentosController < ApplicationController
  require 'csv'

  before_action :set_recebimento, only: %i[ show update edit delete recibo ]

  def index
    @recebimentos = Recebimento.all.order(data: :desc)
    respond_to do |format|
      format.html
      format.csv do
        send_data Recebimento.para_csv(@recebimentos), filename: "#{Rails.application.class.module_parent_name.to_s}-relatorio-recebimentos_#{Date.today}.csv", type: 'text/csv'
      end
    end
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
    if params[:recebimento][:direto_profissional]
      p = params[:recebimento]
      ProfissionalFinanceiroRepasse.where(id: p[:id]).first_or_create.update(profissional_id: Acompanhamento.find(p[:acompanhamento_id]).profissional.id, valor: p[:valor], data: p[:data], modalidade_id: p[:modalidade_id])
    end

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
