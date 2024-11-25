class ProfissionaisController < ApplicationController
  paginas_que_precisam_de_validacao = %i[ new edit update delete acompanhamentos new_profissional_horarios create_profissional_horarios update_profissional_horarios destroy_profissional_horarios contrato_modelos novo_contrato_modelo agenda ]
  # before_action :set_profissional, only: paginas_que_precisam_de_validacao + [:show] - [:new]
  # before_action :validar_usuario, only: paginas_que_precisam_de_validacao
  before_action :set_profissional, except: %i[ index new ]
  before_action :validar_usuario, except: %i[ index show ]

  include Pagy::Backend

  def index
    @profissionais = params[:nome].present? ? Profissional.query_like_nome(params[:nome]) : Profissional.all
    if !usuario_atual
      @profissionais = @profissionais.que_realiza_atendimentos
    end

    if params[:sexo].present?
      @profissionais = params[:sexo].to_sym == :feminino ? @profissionais.mulheres : @profissionais.homens
    end

    if params[:funcao].present?
      @profissionais = @profissionais.where(profissional_funcao_id: params[:funcao])
    end

    if params[:pais].present?
      @profissionais = @profissionais.joins(:pessoa).where(pessoa: { pais_id: params[:pais] })
    end

    if params[:local_atendimento].present?
      @profissionais = @profissionais.no_local_de_atendimento_por_id(params[:local_atendimento]).uniq
    end

    @contagem = @profissionais.count

    @params = params.permit %i[nome sexo funcao pais local_atendimento]

    respond_to do |format|
      format.html do
        @pagy, @profissionais = pagy(@profissionais, items: 9)
        @params = params.permit(:nome, :sexo, :funcao)

        if hx_request?
          render partial: "profissionais/profissionais-container", locals: {profissionais: @profissionais}
        end
      end

      format.csv do
        send_data @profissionais.para_csv, filename: "profissionais_#{@params.to_h.compact.map { |k,v| "#{k&.to_s}=#{v&.to_s}"}.join "_"}.csv"
      end

      format.json
    end
  end

  def show
  end

  def new
    @profissional_funcao = ProfissionalFuncao.new
    if hx_request?
      render partial: "profissional_funcoes/form-tabela", locals: {profissional_funcao: @profissional_funcao}
      return
    end
  end

  def edit
  end

  def create
    @profissional = Profissional.new(profissional_params)

    respond_to do |format|
      if @profissional.save
        format.html { redirect_to profissional_url(@profissional), notice: "profissional was successfully created." }
        format.json { render :show, status: :created, location: @profissional }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @profissional.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @profissional.update(profissional_params)
        format.html { redirect_to profissional_url(@profissional), notice: "Profissional atualizado com sucesso!" }
        format.json { render :show, status: :ok, location: @profissional }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render :json, @profissional.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  end

  def acompanhamentos
    if !(usuario_atual.secretaria? || usuario_atual.corpo_clinico?)
      erro403
      return
    end

    @acompanhamentos = @profissional.acompanhamentos.order(data_inicio: :desc)

    if params[:tipo].presence
      @acompanhamentos = @acompanhamentos.where(acompanhamento_tipo_id: params[:tipo])
    end

    if params[:status].present?
      case params[:status].to_sym
      when :em_andamento
        @acompanhamentos = @acompanhamentos.em_andamento
      when :finalizado
        @acompanhamentos = @acompanhamentos.finalizados
      when :suspenso
        @acompanhamentos = @acompanhamentos.suspensos
      end
    end

    if params[:paciente].present?
      like =  params[:paciente].to_s
      query = "LOWER(pessoas.nome || ' ' || COALESCE(pessoas.nome_do_meio, '') || ' '|| pessoas.sobrenome) LIKE ?", "%#{like}%"
      if Rails.configuration.database_configuration[Rails.env]["adapter"].downcase == "mysql"
        query = "LOWER(CONCAT(pessoas.nome, ' ', COALESCE(pessoas.nome_do_meio, ''), ' ', pessoas.sobrenome)) LIKE ?", "%#{like}%"
      end
      @acompanhamentos = @acompanhamentos.joins(:pessoa).where(query)
    end

    @contagem = @acompanhamentos.count
    @params = params.permit(:tipo, :status, :paciente)

    respond_to do |format|
      nome_documento = "#{nome_do_site&.parameterize}_#{@profissional.nome_completo.parameterize}_acompanhamentos_#{@params.to_h.map { |k,v| v&.to_s }.join("_")}"
      format.html do
        @pagy, @acompanhamentos = pagy(@acompanhamentos, items: 9)
      end

      format.csv do
        send_data @acompanhamentos.para_csv,
          type: "text/csv",
          filename: "#{nome_documento}.csv"
      end
    end
  end
  
  def new_profissional_horario
    @profissional_horario = ProfissionalHorario.new(profissional: @profissional)
  end

  def create_profissional_horario
    profissional_params[:profissional] = @profissional
    @profissional_horario = ProfissionalHorario
  end

  def update_profissional_horario
  end

  def destroy_profissional_horario
  end

  def contrato_modelos
  end

  def novo_contrato_modelo
    @profissional_contrato_modelo = ProfissionalContratoModelo.new(profissional: @profissional)
  end

  def agenda
    @profissional_horarios = ProfissionalHorario.where(profissional: @profissional)
  end

  def financeiro
    @atendimento_valores = @profissional.atendimento_valores.em_ordem(false).first(5)
    @recebimentos = @profissional.recebimentos.em_ordem(:desc).first(5)
    @profissional_financeiro_repasses = @profissional.profissional_financeiro_repasses.em_ordem(false).first(5)
  end

  def atendimento_valores
    @de = params[:de]&.to_date || Date.today.beginning_of_month
    @ate = params[:ate]&.to_date || Date.today.end_of_month

    @atendimento_valores = @profissional.atendimento_valores.do_periodo(@de..@ate)

    @params = params.permit %i[ de ate ]

    respond_to do |format|
      nome_documento = "#{nome_do_site&.parameterize}_#{@profissional.nome_completo.parameterize}_atendimento-valores_#{@de}_#{@ate}"
      format.html

      format.csv do
        send_data @atendimento_valores.para_csv,
          format: "text/csv",
          filename: "#{nome_documento}.csv"
      end

      format.xlsx do
        render "atendimento_valores/index"
        set_xlsx_header "#{nome_documento}.csv"
      end
    end
  end

  def financeiro_repasses
    @de = params[:de]&.to_date || Date.today.beginning_of_month
    @ate = params[:ate]&.to_date || Date.today.end_of_month

    @params = params.permit %i[ de ate ]

    @profissional_financeiro_repasses = @profissional.profissional_financeiro_repasses.do_periodo(@de..@ate)

    respond_to do |format|
      nome_documento = "#{nome_do_site&.parameterize}_#{@profissional.nome_completo.parameterize}_financeiro-repasses_#{@params.to_h.map{ |k,v| "#{k}=#{v}" }.join("_")}"
      format.html

      format.csv do
        send_data @@profissional_financeiro_repasses.para_csv,
          format: "text/csv",
          filename: "#{nome_documento}.csv"
      end

      format.xlsx do
        render "profissional_financeiro_repasses/index"
        set_xlsx_header "#{nome_documento}.csv"
      end
    end
  end

  def recebimentos
    @de = params[:de]&.to_date || Date.today.beginning_of_month
    @ate = params[:ate]&.to_date || Date.today.end_of_month
    @num_itens = params[:n_itens] || 10

    @params = params.permit :de, :ate, :num_itens, :page

    @recebimentos = @profissional.recebimentos.do_periodo(@de..@ate)
    @recebimentos_totais = @recebimentos
    respond_to do |format|
      nome_documento = "#{nome_do_site&.parameterize}_#{@profissional.nome_completo.parameterize}_recebimentos_#{@params.to_h.except(:num_itens).map { |k,v| v&.to_s }.join "_"}"

      format.html do
        @pagy, @recebimentos = pagy(@recebimentos, items: @num_itens)

        if hx_request?
          render partial: "recebimentos-tabela", locals: {profissional: @profissional, recebimentos: @recebimentos, recebimentos_totais: @recebimentos_totais }
        end
      end
      
      format.csv do
        send_data @recebimentos.para_csv,
          filename: "#{nome_documento}.csv",
          type: "text/csv"
      end

      format.xlsx do
        render "recebimentos/index"
        set_xlsx_header "#{nome_documento}.csv"
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
    end
  end

  def folgas
    set_de_ate Date.current.beginning_of_year, Date.current.end_of_year
    @profissional_folgas = @profissional.profissional_folgas.com_inicio_no_periodo @de..@ate

    if params[:motivo].presence
      @profissional_folgas = @profissional_folgas.do_motivo_com_id params[:motivo]
    end

    @profissional_folgas_totais = @profissional_folgas.count
    @params = params.permit %i[ de ate motivo ]

    @pagy, @profissional_folgas = pagy(@profissional_folgas, items: 6)
  end

  def new_folga
    @profissional_folga = ProfissionalFolga.new profissional: @profissional, data_inicio: Date.current, data_final: Date.current
    # render json: @profissional_folga
  end

  def edit_folga
    @profissional_folga = ProfissionalFolga.find params[:profissional_folga_id]
  end

  def destroy_folga
    @profissional_folga = ProfissionalFolga.find params[:profissional_folga_id]

    @profissional_folga.destroy

    respond_to do |format|
      format.html { redirect_to folgas_profissional_path(@profissional), notice: "Folga excluída com sucesso." }
      format.json { head :no_content }
    end
  end

  private

  def set_profissional
    @profissional = Profissional.find(params[:id])
  end

  def profissional_params
    params.require(:profissional).permit(:pessoa_id, :profissional_funcao_id, :documento_regiao_id, :documento_valor, :chave_pix_01, :chave_pix_02, :bio, profissional_horarios: [:profissional_id, :semana_dia_id, :horario])
  end

  def validar_usuario
    if usuario_atual.nil? || !(usuario_atual.corpo_clinico? || usuario_atual.secretaria?)
      render file: "#{Rails.root}/public/404.html", status: 403
    end
  end

  def set_xlsx_header nome_documento=""
    response.headers["Content-Disposition"] = "attachment; filename=#{nome_documento}.xlsx"
  end
end
