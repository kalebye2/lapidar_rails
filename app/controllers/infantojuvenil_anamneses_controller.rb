class InfantojuvenilAnamnesesController < ApplicationController
  before_action :set_infantojuvenil_anamnese, only: %i[ show edit update delete ]
  before_action :validar_usuario
  before_action :validar_edicao, only: %i[ edit update destroy ]

  include Pagy::Backend

  def index
    # @infantojuvenil_anamneses = InfantojuvenilAnamnese.all

    set_de_ate Date.current.beginning_of_year, Date.current.end_of_year

    @infantojuvenil_anamneses = InfantojuvenilAnamnese.do_periodo(@de..@ate)

    if params[:pessoa].present?
      @infantojuvenil_anamneses = @infantojuvenil_anamneses.query_pessoa_like_nome(params[:pessoa])
    end
    if params[:responsavel].present?
      @infantojuvenil_anamneses = @infantojuvenil_anamneses.query_responsavel_like_nome(params[:responsavel])
    end

    if params[:profissional].present?
      @infantojuvenil_anamneses = @infantojuvenil_anamneses.do_profissional_com_id(params[:profissional])
    end

    @params = params.permit(:de, :ate, :pessoa, :profissional, :responsavel)
    @contagem = @infantojuvenil_anamneses.count
    @pagy, @infantojuvenil_anamneses = pagy(@infantojuvenil_anamneses, items: 9)
  end

  def show
    nome_documento = "anamnese-infantojuvenil_#{@infantojuvenil_anamnese.pessoa.nome_completo.parameterize}_#{@infantojuvenil_anamnese.data}"
    respond_to do |format|
      format.html

      format.md do
        response.headers["Content-Type"] = "text/markdown"
        response.headers["Content-Disposition"] = "attachment; filename=#{nome_documento}.md"
      end

      format.pdf do
        send_data InfantojuvenilAnamnesePdf.new(@infantojuvenil_anamnese).render,
          filename: "#{nome_documento}.pdf",
          type: "application/pdf",
          disposition: :inline
      end
      # format.md do
      #   response.headers['Content-Type'] = "text/markdown"
      #   response.headers['Content-Disposition'] = "attachment; filename=anamnese-infantojuvenil_#{@infantojuvenil_anamnese.pessoa.nome_completo.parameterize}_#{@infantojuvenil_anamnese.atendimento.data}.md"
      # end
    end
  end

  def new
    @infantojuvenil_anamnese = InfantojuvenilAnamnese.new
  end

  def create
    @infantojuvenil_anamnese = InfantojuvenilAnamnese.new(infantojuvenil_anamnese_params)
    respond_to do |format|
      if @infantojuvenil_anamnese.save
        format.html do
          redirect_to infantojuvenil_anamnese_path(@infantojuvenil_anamnese, notice: "Anamnese gerada com sucesso!")
        end
        format.json { render :show, status: :created, location: @infantojuvenil_anamnese }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @infantojuvenil_anamnese.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    respond_to do |format|
      format.html do
        if hx_request?
          render partial: "infantojuvenil_anamneses/tabela-dados-principais-edit", locals: {infantojuvenil_anamnese: @infantojuvenil_anamnese}
          return
        else
        end
      end
    end
  end

  def update
    if params[:infantojuvenil_anamnese].present?
      p infantojuvenil_anamnese_params
      @infantojuvenil_anamnese.update(infantojuvenil_anamnese_params)
    end
    if params[:gestacao].present?
      @gestacao.update(gestacao_params)
    end
    if params[:alimentacao].present?
      @alimentacao.update(alimentacao_params)
    end
    if params[:psicomotricidade].present?
      @psicomotricidade.update(psicomotricidade_params)
    end
    if params[:sono].present?
      @sono.update(sono_params)
    end
    if params[:socioafetividade].present?
      @socioafetividade.update(socioafetividade_params)
    end
    if params[:comunicacao].present?
      @comunicacao.update(comunicacao_params)
    end
    if params[:manipulacao].present?
      @manipulacao.update(manipulacao_params)
    end
    if params[:saude_historico].present?
      @saude_historico.update(saude_historico_params)
    end
    if params[:escola_historico].present?
      @escola_historico.update(escola_historico_params)
    end
    if params[:sexualidade].present?
      @sexualidade.update(sexualidade_params)
    end
    if params[:familia_historico].present?
      @familia_historico.update(familia_historico_params)
    end

    if params[:pessoa].present?
      @infantojuvenil_anamnese.pessoa.update(pessoa_params)
    end

    if hx_request?
      render :show
    else
    end
  end

  def delete
  end

  private

  def set_infantojuvenil_anamnese
    @infantojuvenil_anamnese = InfantojuvenilAnamnese.find(params[:id])
    @alimentacao = @infantojuvenil_anamnese.alimentacao
    @sexualidade = @infantojuvenil_anamnese.sexualidade
    @psicomotricidade = @infantojuvenil_anamnese.psicomotricidade
    @sono = @infantojuvenil_anamnese.sono
    @escola_historico = @infantojuvenil_anamnese.escola_historico
    @socioafetividade = @infantojuvenil_anamnese.socioafetividade
    @saude_historico = @infantojuvenil_anamnese.saude_historico
    @comunicacao = @infantojuvenil_anamnese.comunicacao
    @familia_historico = @infantojuvenil_anamnese.familia_historico
    @gestacao = @infantojuvenil_anamnese.gestacao
    @manipulacao = @infantojuvenil_anamnese.manipulacao

    # usuario atual é o profissional responsável?
    @usuario = usuario_atual == @infantojuvenil_anamnese.profissional.usuario
  end

  def validar_usuario
    if usuario_atual.nil? || !(usuario_atual.corpo_clinico || usuario_atual.secretaria?)
      render file: "#{Rails.root}/public/404.html", status: 403
      return
    end
  end

  def validar_edicao
    if usuario_atual.nil? || !(usuario_atual.secretaria? || usuario_atual.profissional == @infantojuvenil_anamnese.profissional)
      render file: "#{Rails.root}/public/404.html", status: 403
      return
    end
  end

  def infantojuvenil_anamnese_params
    params.require(:infantojuvenil_anamnese).permit(
      :atendimento_id,
      :pessoa_id,
      :pessoa_responsavel_id,
      :profissional_id,
      :data,
      :acompanhamento_motivo,
      :data_consulta,
      :diagnostico_preliminar,
      :plano_tratamento,
      :prognostico,
      infantojuvenil_anamnese_gestacao: [
        :infantojuvenil_anamnese_id,
        :mae_diabetes,
        :desejada,
        :idade_pai,
        :idade_mae,
        :irmaos_mais_velhos,
        :irmaos_mais_novos,
        :gestacao_anterior_meses,
        :abortos_anteriores,
        :mae_saude,
        :data_pre_natal,
        :mae_sensacoes,
        :mae_internacoes,
        :mae_enjoos,
        :mae_vomitos,
        :mae_traumatismo,
        :mae_convulsoes,
        :mae_medicamentos,
        :parto_local_id,
        :parto_tipo_id,
        :nascimento_peso_g,
        :nascimento_comprimento_cm,
        :gestacao_semanas,
        :nascimento_crianca_condicoes,
        :nascimento_reacao_pai,
        :nascimento_reacao_mae,
        :nascimento_reacao_irmaos,
        :desenvolvimento_parto,
        :outras_consideracoes
      ])
  end

  def pessoa_params
    params.require(:pessoa).permit(:data_nascimento, :feminino)
  end

  def acompanhamento_params
    params.require(:acompanhamento).permit(:motivo)
  end

  def gestacao_params
    params.require(:gestacao).permit(
      :infantojuvenil_anamnese_id,
      :desejada,
      :mae_diabetes,
      :idade_pai,
      :idade_mae,
      :irmaos_mais_velhos,
      :irmaos_mais_novos,
      :gestacao_anterior_meses,
      :abortos_anteriores,
      :mae_saude,
      :data_pre_natal,
      :mae_sensacoes,
      :mae_internacoes,
      :mae_enjoos,
      :mae_vomitos,
      :mae_traumatismo,
      :mae_convulsoes,
      :mae_medicamentos,
      :parto_local_id,
      :parto_tipo_id,
      :nascimento_peso_g,
      :nascimento_comprimento_cm,
      :gestacao_semanas,
      :nascimento_crianca_condicoes,
      :nascimento_reacao_pai,
      :nascimento_reacao_mae,
      :nascimento_reacao_irmaos,
      :desenvolvimento_parto,
      :outras_consideracoes
    )
  end

  def alimentacao_params
    params.require(:alimentacao).permit(
      :infantojuvenil_anamnese_id,
      :solida_meses,
      :succao_boa,
      :degluticao_boa,
      :usou_mamadeira,
      :comida_sal_introducao_meses,
      :desmame_meses,
      :rejeicao,
      :comer_sozinho_inicio_meses,
      :comer_sozinho_inicio_alimento,
      :comportamento_mesa,
      :precisa_ajuda,
      :alimentacao_atual,
      :outras_consideracoes
    )
  end

  def psicomotricidade_params
    params.require(:psicomotricidade).permit(InfantojuvenilAnamnesePsicomotricidade.attribute_names.map(&:to_sym))
  end

  def sono_params
    params.require(:sono).permit(InfantojuvenilAnamneseSono.attribute_names.map(&:to_sym))
  end

  def socioafetividade_params
    params.require(:socioafetividade).permit(InfantojuvenilAnamneseSocioafetividade.attribute_names.map(&:to_sym))
  end

  def comunicacao_params
    params.require(:comunicacao).permit(InfantojuvenilAnamneseComunicacao.attribute_names.map(&:to_sym))
  end

  def manipulacao_params
    params.require(:manipulacao).permit(InfantojuvenilAnamneseManipulacao.attribute_names.map(&:to_sym))
  end

  def saude_historico_params
    params.require(:saude_historico).permit(InfantojuvenilAnamneseSaudeHistorico.attribute_names.map(&:to_sym))
  end

  def escola_historico_params
    params.require(:escola_historico).permit(InfantojuvenilAnamneseEscolaHistorico.attribute_names.map(&:to_sym))
  end

  def sexualidade_params
    params.require(:sexualidade).permit(InfantojuvenilAnamneseSexualidade.attribute_names.map(&:to_sym))
  end

  def familia_historico_params
    params.require(:familia_historico).permit(InfantojuvenilAnamneseFamiliaHistorico.attribute_names.map(&:to_sym))
  end
end
