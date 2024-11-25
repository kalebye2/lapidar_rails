class ProfissionalFolgasController < ApplicationController
  before_action :set_profissional_folga, only: %i[ show edit update destroy ]
  before_action :validar_usuario
  require 'csv'
  include Pagy::Backend

  # GET /profissional_folgas or /profissional_folgas.json
  def index
    set_de_ate Date.current.beginning_of_year, Date.current.end_of_year
    @profissional_folgas = usuario_atual.secretaria? ? ProfissionalFolga.com_inicio_no_periodo(@de..@ate) : usuario_atual.profissional.profissional_folgas.com_inicio_no_periodo(@de..@ate)
    @profissional_folgas_totais = @profissional_folgas.count

    if params[:profissional].presence
      @profissional = Profissional.find(params[:profissional])
      @profissional_folgas = @profissional_folgas.do_profissional @profissional
    end

    if params[:motivo].presence
      @folga_motivo = ProfissionalFolgaMotivo.find(params[:motivo])
      @profissional_folgas = @profissional_folgas.do_motivo @folga_motivo
    end

    @params = params.permit %i[ profissional motivo de ate id page ]

    @pagy, @profissional_folgas = pagy(@profissional_folgas, items: 9)
  end

  # GET /profissional_folgas/1 or /profissional_folgas/1.json
  def show
  end

  # GET /profissional_folgas/new
  def new
    @profissional_folga = ProfissionalFolga.new data_inicio: Date.current, data_final: Date.current
  end

  # GET /profissional_folgas/1/edit
  def edit
  end

  # POST /profissional_folgas or /profissional_folgas.json
  def create
    @profissional_folga = ProfissionalFolga.new(profissional_folga_params)

    respond_to do |format|
      if @profissional_folga.save
        # format.html { redirect_to profissional_folga_url(@profissional_folga), notice: "Profissional folga was successfully created." }
        format.html do
          if @profissional
            redirect_to folgas_profissional_url(@profissional), notice: "Folga registrada para #{@profissional.nome_abreviado}"
          else
          redirect_to profissional_folgas_url, notice: "Folga registrada com sucesso"
          end
        end
        format.json { render :show, status: :created, location: @profissional_folga }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @profissional_folga.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profissional_folgas/1 or /profissional_folgas/1.json
  def update
    respond_to do |format|
      if @profissional_folga.update(profissional_folga_params)
        format.html do
          if params[:profissional].presence
            redirect_to folgas_profissional_url(@profissional_folga.profissional), notice: "Folga atualizada com sucesso"
          else
          # redirect_to profissional_folga_url(@profissional_folga), notice: "Folga atualizada com sucesso"
          redirect_to profissional_folgas_url, notice: "Folga atualizada com sucesso"
          end
        end
        format.json { render :show, status: :ok, location: @profissional_folga }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @profissional_folga.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profissional_folgas/1 or /profissional_folgas/1.json
  def destroy
    @profissional_folga.destroy

    respond_to do |format|
      format.html do
        if hx_request?
          index
          render partial: "profissional_folgas_container", locals: { profissional_folgas: @profissional_folgas, profissional_folgas_totais: @profissional_folgas_totais }
        else
          redirect_to profissional_folgas_url, notice: "Folga excluída com sucesso."
        end
      end
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profissional_folga
      @profissional_folga = ProfissionalFolga.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def profissional_folga_params
      params.fetch(:profissional_folga, {}).permit %i[ data_inicio data_final profissional_folga_motivo_id profissional_id ]
    end

    def validar_usuario
      if !(usuario_atual.secretaria? || usuario_atual.corpo_clinico?)
        erro403
        return
      end
    end
end
