class ProfissionalHorariosController < ApplicationController
  before_action :set_profissional_horario, only: %i[ show edit update destroy ]
  before_action :validar_usuario

  # GET /profissional_horarios or /profissional_horarios.json
  def index
    @profissional_horarios = ProfissionalHorario.all
  end

  # GET /profissional_horarios/1 or /profissional_horarios/1.json
  def show
  end

  # GET /profissional_horarios/new
  def new
    @profissional_horario = ProfissionalHorario.new
  end

  # GET /profissional_horarios/1/edit
  def edit
  end

  # POST /profissional_horarios or /profissional_horarios.json
  def create
    @profissional_horario = ProfissionalHorario.new(profissional_horario_params)
    if @profissional then @profissional_horario.profissional = @profissional end

    respond_to do |format|
      if @profissional_horario.save
          format.html do
            if params[:de_profissional].presence
              if hx_request?
                render partial: "profissionais/tabela-agenda", locals: { profissional: @profissional_horario.profissional, pode_deletar: true }
              else
                redirect_to profissional_path(@profissional), notice: "Horário registrado"
              end
            else
              format.html { redirect_to profissional_horario_url(@profissional_horario), notice: "Horário criado com sucesso" }
            end
          end
        format.json { render :show, status: :created, location: @profissional_horario }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @profissional_horario.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profissional_horarios/1 or /profissional_horarios/1.json
  def update
    respond_to do |format|
      the_params = profissional_horario_params
      if @profissional then the_params[:profissional_id] = @profissional.id end

      if @profissional_horario.update(the_params)
        format.html { redirect_to profissional_horario_url(@profissional_horario), notice: "Profissional horario was successfully updated." }
        format.json { render :show, status: :ok, location: @profissional_horario }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @profissional_horario.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profissional_horarios/1 or /profissional_horarios/1.json
  def destroy
    profissional = @profissional_horario.profissional
    @profissional_horario.destroy

    respond_to do |format|
      format.html do
        if hx_request?
          if params[:de_profissional].presence
            render partial: "profissionais/tabela-agenda", locals: { profissional: profissional }
          else
          end
        else
          redirect_to profissional_horarios_url, notice: "Profissional horario was successfully destroyed."
        end
      end

      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profissional_horario
      @profissional_horario = ProfissionalHorario.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def profissional_horario_params
      params.require(:profissional_horario).permit(:profissional_id, :semana_dia_id, :horario)
    end

    def validar_usuario
      if usuario_atual.nil?
        erro403
        return
      end
    end
end
