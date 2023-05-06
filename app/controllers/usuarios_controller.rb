class UsuariosController < AuthorizationController
  before_action :set_usuario, only: %i[ show edit update destroy pdf]

  # GET /usuarios or /usuarios.json
  def index
    @usuarios = Usuario.all
  end

  # GET /usuarios/1 or /usuarios/1.json
  def show
    respond_to do |format|
      format.html {render :show}
      format.json {render json: @usuario}
      format.pdf {pdf}
    end
  end

  # GET /usuarios/new
  def new
    @usuario = Usuario.new
  end

  # GET /usuarios/1/edit
  def edit
  end

  # POST /usuarios or /usuarios.json
  def create
    @usuario = Usuario.new(usuario_params)

    respond_to do |format|
      if @usuario.save
        format.html { redirect_to usuario_url(@usuario), notice: "Usuario was successfully created." }
        format.json { render :show, status: :created, location: @usuario }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @usuario.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /usuarios/1 or /usuarios/1.json
  def update
    respond_to do |format|
      if @usuario.update(usuario_params)
        format.html { redirect_to usuario_url(@usuario), notice: "Usuario was successfully updated." }
        format.json { render :show, status: :ok, location: @usuario }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @usuario.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /usuarios/1 or /usuarios/1.json
  def destroy
    @usuario.destroy

    respond_to do |format|
      format.html { redirect_to usuarios_url, notice: "Usuario was successfully destroyed." }
      format.json { head :no_content }
    end
  end


  # pdf
  def pdf
    pdf = Prawn::Document.new
    pdf.font Rails.root.join("public/assets/fonts/LinBiolinum_R.otf")
    #titulo
    pdf.text "FICHA DO USUÁRIO", size: 10, color: "c51422", align: :right

    #nome
    pdf.text "#{@usuario.nome} #{@usuario.sobrenome}", size: 48, color: "c51422", align: :center


    send_data(pdf.render,
              filename: "#{@usuario.nome} #{@usuario.sobrenome}.pdf",
              type: "application/pdf",
              disposition: "inline"
              )
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_usuario
      @usuario = Usuario.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def usuario_params
      params.require(:usuario).permit(:nome, :sobrenome, :cpf, :fone_cod_pais, :fone_cod_area, :fone_num, :feminino, :civil_estado_id, :instrucao_grau_id, :data_nascimento, :email, :municipio_id, :endereco_cep, :endereco_logradouro, :endereco_numero, :endereco_complemento, :profissao, :preferencia_contato)
    end
end
