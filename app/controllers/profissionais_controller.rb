class ProfissionaisController < ApplicationController
  paginas_que_precisam_de_validacao = %i[ new show edit update delete acompanhamentos new_profissional_horarios create_profissional_horarios update_profissional_horarios destroy_profissional_horarios ]
  before_action :set_profissional, only: paginas_que_precisam_de_validacao
  before_action :validar_usuario, only: paginas_que_precisam_de_validacao

  include Pagy::Backend

  def index
    query = "LOWER(nome || ' ' || COALESCE(nome_do_meio, '') || ' '|| sobrenome) LIKE ?", "%#{params[:q].to_s.downcase}%"
    if Rails.configuration.database_configuration[Rails.env]["adapter"].downcase == "mysql"
      query = "LOWER(CONCAT(nome, ' ', COALESCE(nome_do_meio, ''), ' ', sobrenome)) LIKE ?", "%#{params[:q].to_s.downcase}%"
    end
    @profissionais = params[:q].present? ? Profissional.joins(:pessoa).where(query) : Profissional.all.joins("JOIN pessoas ON profissionais.pessoa_id = pessoas.id").order(nome: :asc, sobrenome: :asc)
    if params[:ajax].present?
      if params[:q].present?
        @pagy = nil
      else
        @pagy, @profissionais = pagy(@profissionais, items: 9)
      end
      render partial: "profissionais/profissionais-container", locals: {profissionais: @profissionais}
    else
      @pagy, @profissionais = pagy(@profissionais, items: 9)
    end
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
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
    @acompanhamentos = @profissional.acompanhamentos
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

  private

  def set_profissional
    @profissional = Profissional.find(params[:id])
  end

  def profissional_params
    params.require(:profissional).permit(:pessoa_id, :profissional_funcao_id, :documento_regiao_id, :documento_valor, :chave_pix_01, :chave_pix_02, :bio)
  end

  def validar_usuario
    if usuario_atual.nil? || !(usuario_atual.corpo_clinico? || usuario_atual.secretaria?)
      render file: "#{Rails.root}/public/404.html", status: 403
    end
  end
end
