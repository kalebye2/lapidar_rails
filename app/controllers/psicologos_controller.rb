class PsicologosController < AuthorizationController
  before_action :set_psicologo, only: %i[ show edit update destroy pdf]

  # GET /psicologos or /psicologos.json
  def index
    @psicologos = Psicologo.all
  end

  # GET /psicologos/1 or /psicologos/1.json
  def show
    respond_to do |format|
      format.html {render :show}
      format.json {render json: @psicologo}
      format.pdf {pdf}
    end
  end

  # GET /psicologos/new
  def new
    @psicologo = Psicologo.new
  end

  # GET /psicologos/1/edit
  def edit
  end

  # POST /psicologos or /psicologos.json
  def create
    @psicologo = Psicologo.new(psicologo_params)

    respond_to do |format|
      if @psicologo.save
        format.html { redirect_to psicologo_url(@psicologo), notice: "Psicologo was successfully created." }
        format.json { render :show, status: :created, location: @psicologo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @psicologo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /psicologos/1 or /psicologos/1.json
  def update
    respond_to do |format|
      if @psicologo.update(psicologo_params)
        format.html { redirect_to psicologo_url(@psicologo), notice: "Psicologo was successfully updated." }
        format.json { render :show, status: :ok, location: @psicologo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @psicologo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /psicologos/1 or /psicologos/1.json
  def destroy
    @psicologo.destroy

    respond_to do |format|
      format.html { redirect_to psicologos_url, notice: "Psicologo was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # pdf
  def pdf
    pdf = Prawn::Document.new
    pdf.font Rails.root.join("public/assets/fonts/LinBiolinum_R.otf")
    #titulo
    pdf.text "FICHA DO PSICÓLOGO", size: 10, color: "c51422", align: :right

    #nome
    pdf.text "#{@psicologo.nome} #{@psicologo.sobrenome}", size: 48, color: "c51422", align: :center
    pdf.text "CRP #{@psicologo.crp_regiao.id.to_s.rjust(2, "0")}/#{@psicologo.crp_valor}", size: 24, align: :center

    pdf.move_down 10
    pdf.stroke_horizontal_rule
    pdf.move_down 10

    pdf.text "#{@psicologo.email}"
    pdf.text "+#{@psicologo.fone_cod_pais} (#{@psicologo.fone_cod_area}) #{@psicologo.fone_num[0,@psicologo.fone_num.size-4]}-#{@psicologo.fone_num[5..-1]}"

    s = @psicologo.feminino ? "FEMININO" : "MASCULINO"
    pdf.text "#{s}"
    pdf.text "#{@psicologo.data_nascimento.strftime("%d/%m/%Y")}"
    pdf.text "#{@psicologo.civil_estado.estado.upcase}"
    pdf.text "#{@psicologo.municipio.nome} - #{Uf.find(@psicologo.municipio.uf_id).sigla}"
    pdf.text "#{@psicologo.bio}"

    send_data(pdf.render,
              filename: "#{@psicologo.nome} #{@psicologo.sobrenome}.pdf",
              type: "application/pdf",
              disposition: "inline"
              )
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_psicologo
      @psicologo = Psicologo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def psicologo_params
      params.require(:psicologo).permit(:nome, :sobrenome, :feminino, :cpf, :data_nascimento, :email, :password, :fone_cod_pais, :fone_cod_area, :fone_num, :civil_estado_id, :crp_regiao_id, :crp_valor, :data_colacao, :municipio_id, :bio, :especializacao_01, :especializacao_02, :chave_pix_01, :chave_pix_02, :papel)
    end


end
