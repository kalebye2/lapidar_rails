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
      @recebimentos = Recebimento.do_periodo(@de..@ate)
      @pessoas = Pessoa.joins(:atendimento_valores).distinct.em_ordem_alfabetica
      @atendimento_valores = AtendimentoValor.joins(:atendimento).where("atendimentos.data" => @de..@ate)
    else
      @profissional = usuario_atual.profissional
      @recebimentos = @profissional.recebimentos.do_periodo(@de..@ate)
      @pessoas = Pessoa.joins(:atendimento_valores).distinct.em_ordem_alfabetica
      @atendimento_valores = @profissional.atendimento_valores.joins(:atendimento).where(atendimento: {data: @de..@ate})
    end
  end

  def index
    recebimento_por_periodo_params

    if params[:profissional].present?
      @recebimentos = @recebimentos.do_profissional_com_id(params[:profissional])
    end

    if params[:pessoa].present?
      @pessoa = params[:pessoa]
      @recebimentos = @recebimentos.query_pessoa_like_nome(params[:pessoa])
    end

    if params[:pagante].present?
      @recebimentos = @recebimentos.query_pagante_like_nome(params[:pagante])
    end

    if params[:modalidade].present?
      @recebimentos = @recebimentos.da_modalidade_com_id(params[:modalidade])
    end

    profissional = @profissional || (Profissional.find(params[:profissional]) unless params[:profissional].blank?) || usuario_atual.profissional
    modalidade = PagamentoModalidade.find(params[:modalidade]) unless params[:modalidade].blank?
    pessoa = params[:pessoa]
    pagante = params[:pagante]

    @params = params.permit(:de, :ate, :pessoa, :pagante, :modalidade, :profissional)

    filename = "#{nome_do_site}-relatorio-recebimentos_#{@de}_#{@ate}_#{profissional.funcao.parameterize}_#{profissional.nome_completo.parameterize}#{"_" + pessoa&.parameterize unless pessoa.blank?}#{"_" + pagante&.parameterize unless pagante.blank?}#{"_" + modalidade&.modalidade unless modalidade.blank?}"

    respond_to do |format|
      format.html do
        if hx_request?
          render partial: "recebimentos-info", locals: { recebimentos: @recebimentos, de: @de, ate: @ate, pessoas: @pessoas, atendimento_valores: @atendimento_valores }
        end
      end

      format.csv do
        send_data Recebimento.para_csv(collection: @recebimentos), filename: "#{filename}.csv", type: 'text/csv'
      end

      format.xlsx do
        response.headers['Content-Disposition'] = "attachment; filename=#{filename}.xlsx"
      end

      format.zip do
        compressed_filestream = Zip::OutputStream.write_buffer do |zos|
          @recebimentos.each do |recebimento|
            titulo = "recibo_#{recebimento.pessoa.nome_completo.parameterize}_#{recebimento.data}_#{recebimento.id}"
            if params[:filetype].to_sym == :pdf
              zos.put_next_entry "#{titulo}.pdf"
              pdf = RecebimentoReciboPdf.new(recebimento)
              zos.print pdf.render
            else
              zos.put_next_entry "#{titulo}.md"
              zos.print recebimento.recibo_markdown
            end
          end
        end
        compressed_filestream.rewind
        send_data compressed_filestream.read, filename: "#{Rails.application.class.module_parent.to_s}_recibos-markdown_#{@de}_#{@ate}_#{usuario_atual.hash}.zip"
      end
    end
  end

  def show
    nome_documento = "recibo_#{@recebimento.beneficiario.nome_completo.parameterize}_#{@recebimento.data}_#{@recebimento.id}"
    respond_to do |format|
      format.html

      format.md do
        response.headers['Content-Type'] = 'text/markdown'
        response.headers['Content-Disposition'] = "attachment; filename=#{nome_documento}.md"
      end

      format.pdf do
        pdf = RecebimentoReciboPdf.new(@recebimento)
        send_data pdf.render,
          filename: "#{nome_documento}.pdf",
          type: "application/pdf",
          disposition: :inline
      end
    end
  end

  def new
    if !(usuario_atual.financeiro? || usuario_atual.profissional == @acompanhamento&.profissional)
      erro403
      return
    end

    @recebimento = Recebimento.new
  end

  def inline_new
    @hx_params = params.permit(:de, :ate, :pessoa, :pagante, :modalidade, :profissional)
    render partial: "recebimentos/table-form", recebimento: Recebimento.new
  end

  def inline_adicionar
    @hx_params = params.permit(:de, :ate, :pessoa, :pagante, :modalidade, :profissional)
    render partial: "recebimentos/table-adicionar"
  end

  def edit
  end

  def create
    @acompanhamento = @acompanhamento || Acompanhamento.find(recebimento_params[:acompanhamento_id])
    if !(usuario_atual.financeiro? || usuario_atual.profissional == @acompanhamento&.profissional)
      erro403
      return
    end
    @recebimento = Recebimento.new(recebimento_params)
    @recebimento.usuario = usuario_atual
    if @acompanhamento then @recebimento.acompanhamento = @acompanhamento end
    if params[:recebimento][:direto_profissional]
      p = params[:recebimento]
      ProfissionalFinanceiroRepasse.create(profissional_id: Acompanhamento.find(p[:acompanhamento_id]).profissional.id, valor: p[:valor], data: p[:data], pagamento_modalidade_id: p[:pagamento_modalidade_id], usuario: usuario_atual)
    end

    respond_to do |format|
      if @recebimento.save
        format.html do
          if hx_request?
            index
            return
          else
            if @acompanhamento
              redirect_to recebimentos_acompanhamento_path(@acompanhamento), notice: "Recebimento criado com sucesso para #{@acompanhamento.tipo.upcase} de #{@acompanhamento.pessoa.nome_abreviado}!"
              return
            elsif @pessoa
              redirect_to recebimentos_pessoa_path(@pessoa), notice: "Recebimento criado com sucesso para #{@pessoa.nome_abreviado}!"
              return
            else
              redirect_to recebimentos_path, notice: "Recebimento was successfully created."
              return
            end
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
    @recebimento.usuario = usuario_atual
    if !usuario_atual.financeiro?
      if !usuario_atual.profissional.acompanhamentos.map(&:id).include?(params[:recebimento][:acompanhamento_id])
        render file: "#{Rails.root}/public/404.html", status: 403
        return
      end
    end
    respond_to do |format|
      if @recebimento.update(recebimento_params)
        if hx_request?
          format.html do
            # recebimentos_por_params
            render partial: "recebimentos/recebimentos-info", locals: { recebimentos: @recebimentos, mes: @mes, ano: @ano, atendimento_valores: @atendimento_valores, pessoas: @pessoas }
            render html: "deu certo"
          end
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
        if hx_request?
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

  def select_acompanhamento
    render partial: "recebimentos/select-acompanhamento", locals: { pessoa: Pessoa.find(params[:acompanhamentos_de]) }
  end

  private

  def set_recebimento
    @recebimento = Recebimento.find(params[:id])
  end

  def recebimento_params
    params.require(:recebimento).permit(:pessoa_pagante_id, :acompanhamento_id, :valor, :data, :pagamento_modalidade_id)
  end

  def validar_usuario
    if usuario_atual.nil? || !(usuario_atual.corpo_clinico? || usuario_atual.financeiro?)
      render file: "#{Rails.root}/public/404.html", status: 403
    end
  end
end
