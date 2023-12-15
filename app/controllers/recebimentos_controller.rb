class RecebimentosController < ApplicationController
  require 'csv'

  before_action :set_recebimento, only: %i[ show update edit destroy recibo ]
  before_action :validar_usuario#, only: %i[ show update edit delete recibo ]

  def recebimento_vars
    if usuario_atual.financeiro?
    else
    end
  end

  def recebimento_por_periodo_params
    @de = if !params[:de].nil? then params[:de].to_date end || Date.today.beginning_of_month
    @ate = if !params[:ate].nil? then params[:ate].to_date end || Date.today.end_of_month
    if usuario_atual.financeiro?
      @recebimentos = Recebimento.do_periodo(de: @de, ate: @ate)
      @pessoas = Pessoa.joins(:atendimento_valores).distinct.order(nome: :asc, nome_do_meio: :asc, sobrenome: :asc)
      @atendimento_valores = AtendimentoValor.joins(:atendimento).where("atendimentos.data" => @de..@ate)
    else
    end
  end

  def recebimentos_por_params
    @ano = params[:ano] || Date.today.year
    @mes = params[:mes] || Date.today.month
    @ano_mes = "#{@ano}-#{@mes.to_s.rjust(2, "0")}"
    #@recebimentos = nil
    if usuario_atual.financeiro?
      @pessoas = Pessoa.joins(:atendimento_valores).distinct.order(nome: :asc, nome_do_meio: :asc, sobrenome: :asc)
      @atendimento_valores = AtendimentoValor.joins(:atendimento).where("atendimentos.data" => "#{@ano_mes}-01".."#{@ano_mes}-01".to_date.end_of_month.to_s)
      @recebimentos = Recebimento.do_periodo(mes: @mes, ano: @ano)
    else
      @pessoas = usuario_atual.profissional.pacientes
      @atendimento_valores = usuario_atual.profissional.atendimento_valores.joins(:atendimento).where("atendimentos.data" => "#{@ano_mes}-01".."#{@ano_mes}-01".to_date.end_of_month.to_s)
      @recebimentos = usuario_atual.profissional.recebimentos.do_periodo(mes: @mes, ano: @ano)
    end
  end

  def index
    # params[:de].nil? ? recebimentos_por_params : recebimento_por_periodo_params
    recebimento_por_periodo_params
    respond_to do |format|
      format.html do
        if params[:tabela].present? && params[:tabela]
          render partial: "tabela", locals: { recebimentos: @recebimentos, de: @de, ate: @ate }
        end
      end
      format.csv do
        send_data Recebimento.para_csv(collection: @recebimentos), filename: "#{Rails.application.class.module_parent_name.to_s}-relatorio-recebimentos_#{@de}_#{@ate}.csv", type: 'text/csv'
      end
      format.xlsx do
        response.headers['Content-Disposition'] = "attachment; filename=#{Rails.application.class.module_parent_name.to_s}-relatorio-recebimentos_#{@de}_#{@ate}.xlsx"
      end
      format.zip do
        compressed_filestream = Zip::OutputStream.write_buffer do |zos|
          @recebimentos.each do |recebimento|
            zos.put_next_entry "recibo_#{recebimento.pessoa.nome_completo.parameterize}_#{recebimento.data}_#{recebimento.id}.md"
            zos.print recebimento.recibo_markdown
          end
        end
        compressed_filestream.rewind
        send_data compressed_filestream.read, filename: "recebimentos_#{@de}_#{@ate}.zip"
      end
    end
  end

  def show
    respond_to do |format|
      format.html
      format.md do
        response.headers['Content-Type'] = 'text/markdown'
        response.headers['Content-Disposition'] = "attachment; filename=recibo_#{@recebimento.beneficiario.nome_completo.parameterize}_#{@recebimento.data}.md"
      end
    end
  end

  def new
    @recebimento = Recebimento.new
  end

  def inline_new
    render partial: "recebimentos/table-form", recebimento: Recebimento.new
  end

  def inline_adicionar
    render partial: "recebimentos/table-adicionar"
  end

  def edit
  end

  def create
    if !usuario_atual.financeiro?
      if !usuario_atual.profissional.acompanhamentos.map(&:id).include?(params[:recebimento][:acompanhamento_id])
        render file: "#{Rails.root}/public/404.html", status: 403
        return
      end
    end
    @recebimento = Recebimento.new(recebimento_params)
    if params[:recebimento][:direto_profissional]
      p = params[:recebimento]
      ProfissionalFinanceiroRepasse.create(profissional_id: Acompanhamento.find(p[:acompanhamento_id]).profissional.id, valor: p[:valor], data: p[:data], modalidade_id: p[:modalidade_id])
    end

    respond_to do |format|
      if @recebimento.save
        format.html do
          if params[:ajax].present?
            recebimentos_por_params
            render partial: "recebimentos/tabela", locals: { recebimentos: @recebimentos, mes: @mes, ano: @ano }
          else
          redirect_to recebimentos_path, notice: "recebimento was successfully created."
          end
        end
        format.json { render :index, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @recebimento.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if !usuario_atual.financeiro?
      if !usuario_atual.profissional.acompanhamentos.map(&:id).include?(params[:recebimento][:acompanhamento_id])
        render file: "#{Rails.root}/public/404.html", status: 403
        return
      end
    end
    respond_to do |format|
      if @recebimento.update(recebimento_params)
        if params[:ajax]
          format.html { render html: "deu certo" }
        end
        format.html { redirect_to recebimentos_path, notice: "recebimento was successfully updated." }
        format.json { render :index, status: :ok}
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @recebimento.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @recebimento.destroy

    respond_to do |format|
      format.html do
        if params[:ajax].present?
          recebimentos_por_params
          render partial: "recebimentos/tabela", locals: { recebimentos: @recebimentos, ano: @ano, mes: @mes }
        else
          redirect_to recebimentos_url
        end
      end
      format.json {head :no_content }
    end
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

  def validar_usuario
    if usuario_atual.nil? || !(usuario_atual.corpo_clinico? || usuario_atual.financeiro?)
      render file: "#{Rails.root}/public/404.html", status: 403
    end
  end
end
