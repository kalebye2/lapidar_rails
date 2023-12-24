class PessoasController < ApplicationController
  require 'csv'

  before_action :set_pessoa, only: %i[ show edit update destroy devolutivas informacoes_extras informacao_extra_edit informacao_extra_new create_parentesco new_parentesco show_parentescos recebimentos financeiro ]
  before_action :validar_usuario#, only: %i[ show edit update destroy devolutivas informacoes_extras informacao_extra_edit informacao_extra_new ]
  include Pagy::Backend

  # GET /pessoas or /pessoas.json
  def index
    if params[:q].present?
      if Rails.configuration.database_configuration[Rails.env]["adapter"].downcase == "mysql"
      @pessoas = Pessoa.where("LOWER(CONCAT(nome, ' ', COALESCE(nome_do_meio, ''), ' ', sobrenome)) LIKE ?", "%#{params[:q].to_s.downcase}%")
      else
        @pessoas = Pessoa.where("LOWER(nome || ' ' || COALESCE(nome_do_meio, '') || sobrenome) LIKE ?", "%#{params[:q].to_s.downcase}%")
      end
    else
      @pessoas = Pessoa.all.order(nome: :asc, nome_do_meio: :asc, sobrenome: :asc)
      @pagy, @pessoas = pagy(@pessoas, items: 9)
    end

    if params[:ajax].present?
      @numero_cadastros = params[:q].present? ? "#{@pessoas.count} cadastros encontrados" : nil
      #@numero_cadastros = 0
      render partial: "pessoas/pessoas-container", locals: { pessoas: @pessoas }
    else
    end
  end

  # GET /pessoas/1 or /pessoas/1.json
  def show
    respond_to do |format|
      format.html
      format.md
      format.pdf do
        nome_documento = "Ficha-de-cadastro_#{@pessoa.nome_completo.parameterize}"
        pdf = PessoaPdf.new(@pessoa)
        send_data pdf.render,
          filename: "#{nome_documento}.pdf",
          type: "application/pdf",
          disposition: :inline
      end
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
    if !params["pessoa"]["cpf"].nil?
      params["pessoa"]["cpf"] = params["pessoa"]["cpf"].gsub(/\D/, '')[-11..]
    end
    respond_to do |format|
      if @pessoa.update(pessoa_params)
        format.html { redirect_to pessoa_url(@pessoa), notice: "Pessoa was successfully updated." }
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
      format.pdf
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
    if params[:ajax].present?
      render partial: "pessoas/parentes", locals: { pessoa: @pessoa }
    end
  end

  def new_parentesco
    @pparentesco = PessoaParentescoJuncao.new
    if params[:ajax].present?
      render partial: "pessoas/form-parente", locals: { pessoa: @pessoa }
      return
    end
  end

  def create_parentesco
    @pparentesco = PessoaParentescoJuncao.new(parentesco_params)
    p parentesco_params.nil?
    @pparentesco.pessoa = @pessoa
    if @pparentesco.save!
    end

    if params[:ajax].present?
      render partial: "pessoas/parentes", locals: { pessoa: @pessoa }
    end
  end

  def destroy_parentesco
  end

  def update_parentesco
  end

  # pdfs
  
  def pdf_ficha

  end


  def pdf_info_extra
    
  end

  def recebimentos
    @de = if !params[:de].nil? then params[:de].to_date end || @pessoa.recebimentos.order(data: :asc).first.data
    @ate = if !params[:ate].nil? then params[:ate].to_date end || @pessoa.recebimentos.order(data: :desc).first.data
    @recebimentos = @pessoa.recebimentos.where(data: @de..@para)
    respond_to do |format|
      format.html
      format.csv do
        send_data Recebimento.para_csv(collection: @recebimentos), type: "text/csv", filename: "#{Rails.application.class.module_parent.to_s}_#{@pessoa.nome_completo.parameterize}_#{@de}_#{@ate}.csv"
      end
      format.zip do
        compressed_filestream = Zip::OutputStream.write_buffer do |zos|
          @pessoa.recebimentos.each do |recebimento|
            zos.put_next_entry "recibo_#{@pessoa.nome_completo.parameterize}_#{recebimento.data}_#{recebimento.id}.md"
            zos.print recebimento.recibo_markdown
          end
        end
        compressed_filestream.rewind
        send_data compressed_filestream.read, filename: "#{Rails.application.class.module_parent}_recibos-markdown_#{@pessoa.nome_completo.parameterize}_#{Date.today}_#{usuario_atual.hash}.zip"
      end
    end
  end

  def financeiro
  end

  def atendimento_valores
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pessoa
      @pessoa = Pessoa.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pessoa_params
      params.require(:pessoa).permit(:nome, :nome_do_meio, :sobrenome, :cpf, :fone_cod_pais, :fone_cod_area, :fone_num, :feminino, :civil_estado_id, :instrucao_grau_id, :data_nascimento, :email, :pais_id, :estado, :cidade, :endereco_cep, :endereco_logradouro, :endereco_numero, :endereco_complemento, :profissao, :preferencia_contato, :imagem_perfil, :pessoa_tratamento_pronome_id, :inverter_pronome_tratamento)
    end

    def parentesco_params
      params.require(:parentesco).permit(%i[ pessoa_id parente_id parentesco_id ])
    end

    def validar_usuario
      if usuario_atual.nil? || !(usuario_atual.corpo_clinico? || usuario_atual.secretaria?)
        render file: "#{Rails.root}/public/404.html", status: 404
      end
    end
end
