class InstrumentoRelatosController < ApplicationController
  before_action :set_instrumento_relato, only: %i[ show edit update delete ]

  def index
    @instrumento_relatos = InstrumentoRelato.joins(:atendimento).order("atendimentos.data" => :desc)
  end

  def show
  end

  def new
    @instrumento_relato = InstrumentoRelato.new
  end

  def edit
  end

  def update
    respond_to do |format|
      if @instrumento_relato.update(instrumento_relato_params)
        format.html { redirect_to instrumento_relato_url(@instrumento_relato), notice: "instrumento_relato was successfully updated." }
        format.json { render :show, status: :ok, location: @instrumento_relato }
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

  private
  def set_instrumento_relato
    @instrumento_relato = InstrumentoRelato.find(params[:id])
  end

  def instrumento_relato_params
    params.require(:instrumento_relato).permit(%i[ atendimento_id instrumento_id relato resultados observacoes ])
  end
end
