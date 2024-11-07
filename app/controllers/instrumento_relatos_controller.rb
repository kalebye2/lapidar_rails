class InstrumentoRelatosController < ApplicationController
  before_action :set_instrumento_relato, only: %i[ show edit update destroy ]

  def index
    set_de_ate
    @instrumento_relatos = InstrumentoRelato.joins(:atendimento).order("atendimentos.data" => :desc)

    respond_to do |format|
      nome_documento = "#{nome_do_site&.parameterize}_#{@instrumento_relatos}"
      format.html

      format.csv do
        send_data @instrumento_relatos.para_csv,
          format: "text/csv",
          filename: "#{nome_documento}.csv"
      end
    end
  end

  def show
    if params.has_key?(:card) && params[:card]
      render partial: "instrumento_relatos/instrumento-card", locals: { instrumento_relato: @instrumento_relato }
      return
    end

    nome_documento = "#{@instrumento_relato.atendimento.data_inicio_verdadeira}_#{@instrumento_relato.pessoa.nome_completo.parameterize}_#{@instrumento_relato.instrumento.nome.parameterize}"

    respond_to do |format|
      format.html do
        if hx_request
        end
      end

      format.pdf do
        pdf = InstrumentoRelatoPdf.new(@instrumento_relato)
        send_data pdf.render,
          filename: "#{nome_documento}.pdf",
          type: "application/pdf",
          disposition: :inline
      end
    end
  end

  def new
      @instrumento_relato = InstrumentoRelato.new
      if params[:atendimento]
        @instrumento_relato.atendimento = Atendimento.find(params[:atendimento])
      end
    if hx_request?
      render 'new_ajax'
      return
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @instrumento_relato.update(instrumento_relato_params)
        if params.has_key?(:card) && params[:card]
          format.html { render partial: "instrumento_relatos/instrumento-card", locals: {instrumento_relato: @instrumento_relato} }
        else
          format.html { redirect_to instrumento_relato_url(@instrumento_relato), notice: "instrumento_relato was successfully updated." }
          format.json { render :show, status: :ok, location: @instrumento_relato }
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @instrumento_relato.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @instrumento_relato = InstrumentoRelato.new(instrumento_relato_params)

    respond_to do |format|
      if @instrumento_relato.save
        format.html { redirect_to instrumento_relato_url(@instrumento_relato), notice: "Relato adequadamente registrado" }
        format.json { render :show, status: :created, location: @instrumento_relato }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @instrumento_relato.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    atendimento = @instrumento_relato.atendimento
    @instrumento_relato.destroy

    respond_to do |format|
      format.html do
        if hx_request?
          render partial: "atendimentos/instrumentos_usados", locals: {atendimento: atendimento, instrumento_relatos: atendimento.instrumento_relatos}
        else
          redirect_to index
        end
      end
    end
  end

  private

  def set_instrumento_relato
    @params = params
    if params[:instrumento_relato].present? && params[:instrumento_relato].class.to_s == "Numeric"
        @instrumento_relato = InstrumentoRelato.find(params[:instrumento_relato])
    else
      @instrumento_relato = InstrumentoRelato.find(params[:id])
    end
  end

  def instrumento_relato_params
    params.require(:instrumento_relato).permit(%i[ atendimento_id instrumento_id relato resultados observacoes ])
  end
end
