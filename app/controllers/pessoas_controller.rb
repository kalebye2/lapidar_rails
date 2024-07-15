class PessoasController < ApplicationController
  require 'csv'

  before_action :set_pessoa, except: [:index, :new, :create]
  before_action :validar_usuario#, only: %i[ show edit update destroy devolutivas informacoes_extras informacao_extra_edit informacao_extra_new ]
  include Pagy::Backend

  # GET /pessoas or /pessoas.json
  def index
    @pessoas = params[:nome].present? ? Pessoa.query_like_nome(params[:nome]).em_ordem_alfabetica : Pessoa.em_ordem_alfabetica

    if params[:sexo].present?
      @pessoas = params[:sexo].to_sym == :feminino ? @pessoas.mulheres : @pessoas.homens
    end

    if params[:profissionais].present?
      @pessoas = ActiveModel::Type::Boolean.new.cast(params[:profissionais]) ? @pessoas.profissionais : @pessoas.nao_profissionais
    end

    if params[:pais].present?
      @pessoas = @pessoas.where(pais: params[:pais])
    end

    if params[:endereco_cidade].present?
      @pessoas = @pessoas.where("LOWER(endereco_cidade) LIKE '%#{params[:endereco_cidade]}%'")
    end
    if params[:endereco_logradouro].present?
      @pessoas = @pessoas.where("LOWER(endereco_logradouro) LIKE '%#{params[:endereco_logradouro]}%'")
    end
    if params[:endereco_bairro].present?
      @pessoas = @pessoas.where("LOWER(endereco_bairro) LIKE '%#{params[:endereco_bairro]}%'")
    end

    @contagem = @pessoas.count
    @params = params.permit(:nome, :sexo, :pais, :endereco_cidade, :endereco_logradouro, :endereco_bairro)

    respond_to do |format|
      format.html do
        @pagy, @pessoas = pagy(@pessoas, items: 9)
        if hx_request?
          render partial: "pessoas/pessoas-container", locals: { pessoas: @pessoas }
        else
        end
      end

      format.csv do
        send_data Pessoa.para_csv(@pessoas),
          filename: "#{nome_do_site&.parameterize}_lapidar_cadastros_#{@params&.to_h&.map { |k,v| "#{k}=#{v}" }&.compact&.join "_"}.csv",
          type: "text/csv"
      end
    end
  end

  # GET /pessoas/1 or /pessoas/1.json
  def show
    nome_documento = "#{@pessoa.nome_completo.parameterize}_ficha-cadastral"
    respond_to do |format|
      format.html
      format.md do
        response.headers["Content-Type"] = "text/markdown"
        response.headers["Content-Disposition"] = "attachment;filename=#{nome_documento}.md"
      end
      format.pdf do
        pdf = PessoaPdf.new(@pessoa)
        send_data pdf.render,
          filename: "#{nome_documento}.pdf",
          type: "application/pdf",
          disposition: :inline
      end

      format.zip do
        compressed_filestream = Zip::OutputStream.write_buffer do |zos|
          fname = @pessoa.nome_completo.parameterize

          zos.put_next_entry "#{fname}/modelo.txt"
          zos.print "Este é o modelo de pasta do cadastro de #{@pessoa.nome_completo} criado por #{usuario_atual.nome_completo}"

          zos.put_next_entry "#{fname}/relatos/modelo.txt"
          zos.print "Esta pasta é para fazer os relatos de #{@pessoa.nome_completo}. Guarde esses relatos em local seguro para proteger o sigilo!"

          zos.put_next_entry "#{fname}/recibos/modelo.txt"
          zos.print "Esta pasta é para os recibos de #{@pessoa.nome_completo}. Os recibos podem ser baixados na aplicação da clínica."

          zos.put_next_entry "#{fname}/reajustes/modelo.txt"
          zos.print "Esta pasta é para os reajustes de #{@pessoa.nome_completo}. Os documentos para os reajustes podem ser baixados na aplicação da clínica."

          zos.put_next_entry "#{fname}/dados-extras/modelo.txt"
          zos.print "Pasta para coletânea de dados extras para #{@pessoa.nome_completo}."

          zos.put_next_entry "#{fname}/exames/modelo.txt"
          zos.print "Pasta para todos os documentos de exames de #{@pessoa.nome_completo}."

          zos.put_next_entry "#{fname}/encaminhamentos/modelo.txt"
          zos.print "Pasta para os encaminhamentos de #{@pessoa.nome_completo}."

          zos.put_next_entry "#{fname}/declaracoes/modelo.txt"
          zos.print "Pasta para as declarações de #{@pessoa.nome_completo}."

          zos.put_next_entry "#{fname}/docs/modelo.txt"
          zos.print "Pasta para documentação extra de #{@pessoa.nome_completo}."
        end

        compressed_filestream.rewind
        send_data compressed_filestream.read, filename: "#{@pessoa.nome_completo.parameterize}.zip"
      end

      format.json
    end
  end

  # GET /pessoas/new
  def new
    @pessoa = Pessoa.new
  end

  # GET /pessoas/1/edit
  def edit
  end

  # POST /pessoas or /pessoas.json
  def create
    @pessoa = Pessoa.new(pessoa_params)
    validar_params

    respond_to do |format|
      if @pessoa.save
        format.html { redirect_to pessoa_url(@pessoa), notice: "Pessoa was successfully created." }
        format.json { render :show, status: :created, location: @pessoa }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pessoa.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pessoas/1 or /pessoas/1.json
  def update
    validar_params
    respond_to do |format|
      if @pessoa.update(pessoa_params)
        format.html { redirect_to pessoa_url(@pessoa), notice: "Cadastro atualizado com sucesso!" }
        format.json { render :show, status: :ok, location: @pessoa }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pessoa.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pessoas/1 or /pessoas/1.json
  def destroy
    @pessoa.destroy

    respond_to do |format|
      format.html { redirect_to pessoas_url, notice: "Pessoa was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def informacoes_extras
    @extra_informacoes = @pessoa.pessoa_extra_informacao.order(data: :asc)
    respond_to do |format|
      format.html
      format.csv do
        send_data PessoaExtraInformacao.para_csv(@extra_informacoes), filename: "#{Rails.application.class.module_parent_name.to_s}_#{@pessoa.nome_completo.parameterize}.csv", type: 'text/csv'
      end
    end
  end

  def informacao_extra_edit
    @extra_informacao = PessoaExtraInformacao.find(params[:extra_info_id])
    respond_to do |format|
      format.html
      format.md do
        conteudo = "*Informação obtida por: #{(@extra_informacao.meio || "meio desconhecido").upcase} em #{@extra_informacao.data.strftime("%d/%m/%Y")}*\n\n---\n#{@extra_informacao.conteudo_material}"
        send_data conteudo, filename: "#{@extra_informacao.pessoa.nome_completo}_#{@extra_informacao.data}_#{(@extra_informacao.meio || "limbo").upcase}.md"
      end
    end
  end

  def informacao_extra_update
    @extra_informacao.update(pessoa_extra_informacao_params)
  end

  def informacao_extra_new
    @extra_informacao = @pessoa.pessoa_extra_informacao.new
  end

  def informacao_extra_create
  end

  ### recursos extras
  # devolutivas
  def devolutivas
    @devolutivas = @pessoa.devolutiva.order(data: :desc)
    respond_to do |format|
      format.html
      format.json
      format.js
    end
  end
  def responsavel_devolutivas
    @devolutivas = @pessoa.responsavel_devolutiva.order(data: :desc)
    respond_to do |format|
      format.html
      format.json
      format.js
      format.pdf
    end
  end

  # parentescos
  def show_parentescos
    if hx_request?
      render partial: "pessoas/parentes", locals: { pessoa: @pessoa }
    end
  end

  def new_parentesco
    @pparentesco = PessoaParentescoJuncao.new
    if hx_request?
      render partial: "pessoas/form-parente", locals: { pessoa: @pessoa }
      return
    end
  end

  def create_parentesco
    @pparentesco = PessoaParentescoJuncao.new(parentesco_params)
    p parentesco_params.nil?
    @pparentesco.pessoa = @pessoa

    respond_to do |format|
      if @pparentesco.save
        format.html do
          if hx_request?
            render partial: "pessoas/parentes", locals: { pessoa: @pessoa }
          end
        end
      else
        format.html do
          if hx_request?
            render partial: "pessoa/form-parente", locals: { pessoa: @pessoa, parente: @pparentesco.parente, parentesco: @pparentesco }, status: "Ocorreu um erro!"
          end
        end
      end
    end
  end

  def edit_parentesco
    @parentesco = PessoaParentescoJuncao.find_by(pessoa: @pessoa, parente: params[:parente_id])
    @parente = @parentesco.parente

    respond_to do |format|
      format.html do
        if hx_request?
          render partial: "pessoas/form-parente", locals: { pessoa: @pessoa, parente: @parente, parentesco: @parentesco }
        end
      end
    end
  end

  def destroy_parentesco
  end

  def update_parentesco
  end

  def show_medicacoes
    if hx_request?
      render partial: "pessoas/medicacao", locals: { pessoa: @pessoa }
    end
  end

  def new_medicacao
    @medicacao = PessoaMedicacao.new
    if hx_request?
      render partial: "pessoas/form-medicacao", locals: { pessoa: @pessoa }
      return
    end
  end

  def create_medicacao
    @pessoa_medicacao = PessoaMedicacao.new(pessoa_medicacao_params)
    @pessoa_medicacao.pessoa = @pessoa

    respond_to do |format|
      if @pessoa_medicacao.save!
        format.html do
          if hx_request?
            render partial: "pessoas/medicacao", locals: { pessoa: @pessoa }
          end
        end
      end
    end
  end

  def edit_medicacao
    @pessoa_medicacao = @pessoa.pessoa_medicacoes.find(params[:med_id])
    if hx_request?
      render partial: "pessoas/form-medicacao", locals: { pessoa: @pessoa, pessoa_medicacao: @pessoa_medicacao }
    end
  end

  def update_medicacao
    @pessoa_medicacao = PessoaMedicacao.find(params[:med_id])
    respond_to do |format|
      if @pessoa_medicacao.update(pessoa_medicacao_params)
        format.html do
          if hx_request?
            render partial: "pessoas/medicacao", locals: { pessoa: @pessoa, pessoa_medicacao: @pessoa_medicacao, notice: "Dados da medicação atualizados" }
          end
        end
      end
    end
  end

  def destroy_medicacao
    @pessoa_medicacao = PessoaMedicacao.find(params[:med_id])
    @pessoa_medicacao.destroy
    respond_to do |format|
      format.html do
        if hx_request?
          render partial: "pessoas/medicacao", locals: { pessoa: @pessoa, pessoa_medicacao: @pessoa_medicacao, notice: "Registro excluído." }
        end
      end
    end
  end

  # pdfs
  
  def pdf_ficha
  end


  def pdf_info_extra
  end

  def recebimentos
    @de = params[:de]&.to_date || Date.today.beginning_of_year
    @ate = params[:ate]&.to_date || Date.today.end_of_year
    @recebimentos = @pessoa.recebimentos.where(data: @de..@para)
    @pagamentos  = @pessoa.recebimentos_pagante.do_periodo(@de..@para)
    nome_documento = "#{Rails.application.class.module_parent.to_s}_recebimentos_#{@pessoa.nome_completo.parameterize}_#{@de}_#{@ate}_#{Time.current.strftime "%Y%m%d%H%M%S"}"

    respond_to do |format|
      format.html

      format.csv do
        send_data Recebimento.para_csv(collection: @recebimentos), type: "text/csv", filename: "#{nome_documento}.csv"
      end

      format.xlsx do
        response.headers['Content-Disposition'] = "attachment; filename=#{nome_documento}.xlsx"
      end

      format.zip do
        filetype = params[:filetype] || :pdf
        compressed_filestream = Zip::OutputStream.write_buffer do |zos|
          @recebimentos.each do |recebimento|
            zos.put_next_entry "recibo_#{@pessoa.nome_completo.parameterize}_#{recebimento.data}_#{recebimento.id}.#{filetype.to_s}"
            case filetype.to_sym
            when :md
              zos.print recebimento.recibo_markdown
            when :pdf
              zos.print RecebimentoReciboPdf.new(recebimento).render
            end
          end
        end
        compressed_filestream.rewind
        send_data compressed_filestream.read, filename: "#{Rails.application.class.module_parent}_recibos-#{filetype}_#{@pessoa.nome_completo.parameterize}_#{Date.today}_#{usuario_atual.hash}.zip"
      end
    end
  end

  def new_recebimento
  end

  def create_recebimento
  end

  def edit_recebimento
  end

  def financeiro
    @de = params[:de]&.to_date || @pessoa.recebimentos.order(data: :asc).first&.data || Date.today.beginning_of_month
    @ate = params[:ate]&.to_date || @pessoa.recebimentos.order(data: :asc).first&.data || Date.today.beginning_of_month
  end

  def atendimento_valores
    @de = params[:de]&.to_date || Date.today.beginning_of_month
    @ate = params[:ate]&.to_date || Date.today.end_of_month
    @atendimento_valores = @pessoa.atendimento_valores.joins(:atendimento).where(atendimentos: {data: @de..@para})

    @params = params.permit(:de, :ate)
    respond_to do |format|
      format.html
      format.pdf
      format.csv do
        send_data @atendimento_valores.para_csv, type: "text/csv", filename: "#{Rails.application.class.module_parent.to_s}_#{@pessoa.nome_completo.parameterize}_#{@de}_#{@ate}.csv"
      end
      format.zip do
      end
    end
  end

  def prontuario
    hoje = Time.current.strftime("%Y%m%d")
    hoje_formatado = Time.current.strftime("%d/%m/%Y")
    nome_documento = "#{@pessoa.nome_completo.parameterize}_prontuario_multiprofissional_#{hoje}_#{Time.current.strftime "%H%M%S"}"
    respond_to do |format|
      format.html
      format.md do
        response.headers['Content-Type'] = 'text/markdown'
        response.headers['Content-Disposition'] = "attachment; filename=#{nome_documento}.md"
      end

      format.pdf do
        pdf = PessoaProntuarioPdf.new(@pessoa)
        send_data pdf.render,
          filename: "#{nome_documento}.pdf",
          type: "application/pdf",
          disposition: :inline
      end
    end
  end

  def acompanhamento_reajustes
  end

  def acompanhamentos
  end

  def new_acompanhamento
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pessoa
      @pessoa = Pessoa.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pessoa_params
      params.require(:pessoa).permit(:nome, :nome_do_meio, :sobrenome, :rg, :cpf, :fone_cod_pais, :fone_cod_area, :fone_num, :feminino, :civil_estado_id, :instrucao_grau_id, :data_nascimento, :email, :pais_id, :endereco_estado, :endereco_cidade, :endereco_bairro, :endereco_cep, :endereco_logradouro, :endereco_numero, :endereco_complemento, :profissao, :preferencia_contato, :imagem_perfil, :pessoa_tratamento_pronome_id, :inverter_pronome_tratamento, :nascimento_cidade, :nascimento_estado, :nascimento_pais_id, :nome_preferido, :usa_whatsapp, :usa_telegram, :bio)
    end

    def parentesco_params
      params.require(:parentesco).permit(%i[ pessoa_id parente_id parentesco_id ])
    end

    def pessoa_medicacao_params
      params.require(:pessoa_medicacao).permit(%i[ pessoa_id medicacao dose motivo data_inicio data_fim ])
    end

    def validar_usuario
      if usuario_atual.nil? || !(usuario_atual.corpo_clinico? || usuario_atual.secretaria?)
        erro403
      end
    end

    def validar_params
      
    end
end
