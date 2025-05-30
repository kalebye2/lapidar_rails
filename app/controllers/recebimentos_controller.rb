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
    recebimentos_por_params

    profissional = @profissional || (Profissional.find(params[:profissional]) unless params[:profissional].blank?) || usuario_atual.profissional
    modalidade = PagamentoModalidade.find(params[:modalidade]) unless params[:modalidade].blank?
    pessoa = params[:pessoa]
    pagante = params[:pagante]

    @params = params.permit(:de, :ate, :pessoa, :pagante, :modalidade, :profissional)

    @cobrar_ate_mes_passado = valores_a_cobrar(..(Date.current - 1.month).end_of_month)
    @cobrar_ate_hoje = valores_a_cobrar

    # @cobrar_ate_mes_passado = Acompanhamento.all.map &:valor_a_cobrar

    filename = "#{nome_do_site&.parameterize}-relatorio-recebimentos_#{@de}_#{@ate}_#{profissional.funcao.parameterize}_#{profissional.nome_completo.parameterize}#{"_" + pessoa&.parameterize unless pessoa.blank?}#{"_" + pagante&.parameterize unless pagante.blank?}#{"_" + modalidade&.modalidade unless modalidade.blank?}"

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
            if params[:filetype]&.to_sym == :pdf
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
        send_data compressed_filestream.read, filename: "#{nome_do_site&.parameterize}_recibos-#{params[:filetype] || "pdf"}_#{@de}_#{@ate}_#{usuario_atual.hash}.zip"
      end

      format.pdf do
        pdf = RecebimentosPdf.new(@recebimentos)
        send_data pdf.render,
          filename: "#{filename}.pdf",
          type: "application/pdf",
          disposition: :inline
      end

      format.json
    end
  end

  def show
    filename = "recibo_#{@recebimento.beneficiario.nome_completo.parameterize}_#{@recebimento.data}_#{@recebimento.id}"
    respond_to do |format|
      format.html

      format.md do
        response.headers['Content-Type'] = 'text/markdown'
        response.headers['Content-Disposition'] = "attachment; filename=#{filename}.md"
      end

      format.pdf do
        pdf = RecebimentoReciboPdf.new(@recebimento)
        send_data pdf.render,
          filename: "#{filename}.pdf",
          type: "application/pdf",
          disposition: :inline
      end

      format.json
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

    valor_final = compor_valor_monetario_de_virgulas params[:recebimento][:valor_real]&.to_s || "0,00"
    params[:recebimento][:valor] = valor_final
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
        erro403
        return
      end
    end
    respond_to do |format|
      valor_final = compor_valor_monetario_de_virgulas params[:recebimento][:valor_real]&.to_s || "0,00"
      params[:recebimento][:valor] = valor_final if valor_final != @recebimento.valor

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

    recebimentos_por_params

    respond_to do |format|
      format.html do
        if hx_request?
          # recebimentos_por_params
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
    filename = "Recibo_#{hoje}"
  end

  def select_acompanhamento
    render partial: "recebimentos/select-acompanhamento", locals: { pessoa: Pessoa.find(params[:acompanhamentos_de]) }
  end

  def cobranca_pendente
    @params = params.permit(:ate, :format)
    data_final = @params[:ate] || Date.current
    periodo = ..data_final
    col_sep = params[:col_sep] || ","
    valores = valores_a_cobrar(periodo)
    filename = "#{nome_do_site&.parameterize}_cobranca_pendente_#{@params.to_h.compact.map { |k,v| "#{k&.to_s}=#{v&.to_s}"}.join("_")}_#{Time.current.to_fs(:number)}"

    case @params[:format]&.downcase&.to_sym
    when :csv
      csv_final = CSV.generate(col_sep: col_sep) do |csv|
        csv << [
          "paciente",
          "responsável",
          "serviço",
          "profissional",
          "valor",
        ]

        valores.each do |valor|
          csv << [
            valor[:paciente]&.nome_completo,
            valor[:responsável]&.nome_completo,
            valor[:acompanhamento]&.tipo&.upcase,
            valor[:profissional]&.descricao_completa,
            valor[:valor] / 100.0,
          ]
        end
      end
      send_data csv_final, filename: "#{filename}.csv", type: "text/csv"
    else
      render html: "No"
    end

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
      erro403
    end
  end

  def valores_a_cobrar periodo = ..Date.current
    Acompanhamento.joins(:pessoa).order("pessoas.nome" => :asc, "pessoas.nome_do_meio" => :asc, "pessoas.sobrenome" => :asc).all.map { |acompanhamento|

      acompanhamento.valor_a_cobrar(periodo) != 0 ? {
        paciente: acompanhamento.pessoa,
        responsável: acompanhamento.pessoa_responsavel,
        acompanhamento: acompanhamento,
        profissional: acompanhamento.profissional,
        valor: acompanhamento.valor_a_cobrar(periodo),
      } : nil
    }.compact
  end

  def recebimentos_por_params
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

  end
end
