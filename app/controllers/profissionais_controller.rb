class ProfissionaisController < ApplicationController
  paginas_que_precisam_de_validacao = %i[ new edit update delete acompanhamentos new_profissional_horarios create_profissional_horarios update_profissional_horarios destroy_profissional_horarios contrato_modelos novo_contrato_modelo agenda ]
  before_action :set_profissional, only: paginas_que_precisam_de_validacao + [:show] - [:new]
  before_action :validar_usuario, only: paginas_que_precisam_de_validacao

  include Pagy::Backend

  def index
    @profissionais = params[:nome].present? ? Profissional.query_like_nome(params[:nome]) : Profissional.all
    if !usuario_atual
      @profissionais = @profissionais.que_realiza_atendimentos
    end

    if params[:sexo].present?
      @profissionais = params[:sexo].to_sym == :feminino ? @profissionais.mulheres : @profissionais.homens
    end

    if params[:funcao].present?
      @profissionais = @profissionais.where(profissional_funcao_id: params[:funcao])
    end

    if params[:pais].present?
      @profissionais = @profissionais.joins(:pessoa).where(pessoa: { pais_id: params[:pais] })
    end

    if params[:local_atendimento].present?
      @profissionais = @profissionais.no_local_de_atendimento_por_id(params[:local_atendimento])
    end

    @contagem = @profissionais.count
    @pagy, @profissionais = pagy(@profissionais, items: 9)
    @params = params.permit(:nome, :sexo, :funcao)

    if hx_request?
      render partial: "profissionais/profissionais-container", locals: {profissionais: @profissionais}
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
    if !(usuario_atual.secretaria? || usuario_atual.corpo_clinico?)
      erro403
      return
    end

    @acompanhamentos = @profissional.acompanhamentos.order(data_inicio: :desc)

    if params[:tipo].presence
      @acompanhamentos = @acompanhamentos.where(acompanhamento_tipo_id: params[:tipo])
    end

    if params[:status].present?
      case params[:status].to_sym
      when :em_andamento
        @acompanhamentos = @acompanhamentos.em_andamento
      when :finalizado
        @acompanhamentos = @acompanhamentos.finalizados
      when :suspenso
        @acompanhamentos = @acompanhamentos.suspensos
      end
    end

    if params[:paciente].present?
      like =  params[:paciente].to_s
      query = "LOWER(pessoas.nome || ' ' || COALESCE(pessoas.nome_do_meio, '') || ' '|| pessoas.sobrenome) LIKE ?", "%#{like}%"
      if Rails.configuration.database_configuration[Rails.env]["adapter"].downcase == "mysql"
        query = "LOWER(CONCAT(pessoas.nome, ' ', COALESCE(pessoas.nome_do_meio, ''), ' ', pessoas.sobrenome)) LIKE ?", "%#{like}%"
      end
      @acompanhamentos = @acompanhamentos.joins(:pessoa).where(query)
    end

    @contagem = @acompanhamentos.count
    @pagy, @acompanhamentos = pagy(@acompanhamentos, items: 9)
    @params = params.permit(:tipo, :status, :paciente)
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

  def contrato_modelos
  end

  def novo_contrato_modelo
    @profissional_contrato_modelo = ProfissionalContratoModelo.new(profissional: @profissional)
  end

  def agenda
    @profissional_horarios = ProfissionalHorario.where(profissional: @profissional)
  end

  private

  def set_profissional
    @profissional = Profissional.find(params[:id])
  end

  def profissional_params
    params.require(:profissional).permit(:pessoa_id, :profissional_funcao_id, :documento_regiao_id, :documento_valor, :chave_pix_01, :chave_pix_02, :bio, profissional_horarios: [:profissional_id, :semana_dia_id, :horario])
  end

  def validar_usuario
    if usuario_atual.nil? || !(usuario_atual.corpo_clinico? || usuario_atual.secretaria?)
      render file: "#{Rails.root}/public/404.html", status: 403
    end
  end
end
