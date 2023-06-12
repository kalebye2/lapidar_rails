class PessoasController < ApplicationController
  before_action :set_pessoa, only: %i[ show edit update destroy devolutivas ]

  # GET /pessoas or /pessoas.json
  def index
    @pessoas = Pessoa.all.order(nome: :asc, sobrenome: :asc)
  end

  # GET /pessoas/1 or /pessoas/1.json
  def show
    respond_to do |format|
      format.html
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
    params["pessoa"]["cpf"] = params["pessoa"]["cpf"].gsub(/\D/, '')[-11..]
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

  # pdfs
  
  def pdf_ficha

  end


  def pdf_info_extra
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pessoa
      @pessoa = Pessoa.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pessoa_params
      params.require(:pessoa).permit(:nome, :nome_do_meio, :sobrenome, :cpf, :fone_cod_pais, :fone_cod_area, :fone_num, :feminino, :civil_estado_id, :instrucao_grau_id, :data_nascimento, :email, :pais_id, :estado, :cidade, :endereco_cep, :endereco_logradouro, :endereco_numero, :endereco_complemento, :profissao, :preferencia_contato)
    end
end
