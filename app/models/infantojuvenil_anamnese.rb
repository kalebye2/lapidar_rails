class InfantojuvenilAnamnese < ApplicationRecord
  include ApplicationHelper

  has_one :infantojuvenil_anamnese_alimentacao
  has_one :infantojuvenil_anamnese_comunicacao
  has_one :infantojuvenil_anamnese_escola_historico
  has_one :infantojuvenil_anamnese_familia_historico
  has_one :infantojuvenil_anamnese_gestacao
  has_one :infantojuvenil_anamnese_manipulacao
  has_one :infantojuvenil_anamnese_psicomotricidade
  has_one :infantojuvenil_anamnese_saude_historico
  has_one :infantojuvenil_anamnese_sexualidade
  has_one :infantojuvenil_anamnese_socioafetividade
  has_one :infantojuvenil_anamnese_sono

  belongs_to :atendimento
  has_one :acompanhamento, through: :atendimento
  has_one :pessoa, through: :acompanhamento
  alias paciente pessoa
  has_one :profissional, through: :acompanhamento
  has_one :pessoa_responsavel, through: :acompanhamento

  accepts_nested_attributes_for :infantojuvenil_anamnese_gestacao
  accepts_nested_attributes_for :pessoa
  accepts_nested_attributes_for :acompanhamento

  scope :do_periodo, -> (periodo) { joins(:atendimento).where(atendimento: {data: periodo}) }

  scope :do_profissional, -> (profissional) { joins(:profissional).where(profissional: { id: profissional.id }) }
  scope :do_profissional_com_id, -> (id) { joins(:profissional).where(profissional: {id: id}) }
  scope :da_pessoa, -> (pessoa) { joins(:pessoa).where(pessoa: {id: pessoa.id}) }
  scope :da_pessoa_com_id, -> (id) { joins(:pessoa).where(pessoa: {id: id}) }
  scope :do_responsavel, -> (responsavel) { joins(:pessoa_responsavel).where(pessoa_responsavel: {id: responsavel.id}) }
  scope :do_responsavel_com_id, -> (id) { joins(:pessoa_responsavel).where(pessoa_responavel: {id: id}) }

  scope :query_pessoa_like_nome, -> (like = "") do
    like = like.to_s
    query = "LOWER(pessoas.nome || ' ' || COALESCE(pessoas.nome_do_meio, '') || ' '|| pessoas.sobrenome) LIKE ?", "%#{like}%"
    if Rails.configuration.database_configuration[Rails.env]["adapter"].downcase == "mysql"
      query = "LOWER(CONCAT(pessoas.nome, ' ', COALESCE(pessoas.nome_do_meio, ''), ' ', pessoas.sobrenome)) LIKE ?", "%#{like}%"
    end
    joins(:pessoa).where(query)
  end
  scope :query_responsavel_like_nome, -> (like = "") do
    like = like.to_s
    query = "LOWER(responsaveis.nome || ' ' || COALESCE(responsaveis.nome_do_meio, '') || ' '|| responsaveis.sobrenome) LIKE ?", "%#{like}%"
    if Rails.configuration.database_configuration[Rails.env]["adapter"].downcase == "mysql"
      query = "LOWER(CONCAT(responsaveis.nome, ' ', COALESCE(responsaveis.nome_do_meio, ''), ' ', responsaveis.sobrenome)) LIKE ?", "%#{like}%"
    end
    joins(:acompanhamento).joins("JOIN pessoas AS responsaveis ON responsaveis.id = acompanhamentos.pessoa_responsavel_id").where(query)
  end

  after_create -> (anamnese) { anamnese.criar_anamnese_completa }

  def identificador
    "#{data.strftime "%Y%m%d"}#{acompanhamento.id}#{pessoa.id}#{pessoa_responsavel&.id}#{profissional.id}#{id}"
  end

  def data
    atendimento.data
  end

  #
  alias alimentacao infantojuvenil_anamnese_alimentacao

  alias comunicacao infantojuvenil_anamnese_comunicacao

  alias escola_historico infantojuvenil_anamnese_escola_historico

  alias familia_historico infantojuvenil_anamnese_familia_historico

  alias gestacao infantojuvenil_anamnese_gestacao

  alias manipulacao infantojuvenil_anamnese_manipulacao

  alias psicomotricidade infantojuvenil_anamnese_psicomotricidade

  alias saude_historico infantojuvenil_anamnese_saude_historico

  alias sexualidade infantojuvenil_anamnese_sexualidade

  alias socioafetividade infantojuvenil_anamnese_socioafetividade
  
  alias sono infantojuvenil_anamnese_sono

  def criar_anamnese_completa
    if infantojuvenil_anamnese_alimentacao.nil? then build_infantojuvenil_anamnese_alimentacao.save! end
    if infantojuvenil_anamnese_comunicacao.nil? then build_infantojuvenil_anamnese_comunicacao.save! end
    if infantojuvenil_anamnese_escola_historico.nil? then build_infantojuvenil_anamnese_escola_historico.save! end
    if infantojuvenil_anamnese_familia_historico.nil? then build_infantojuvenil_anamnese_familia_historico.save! end
    if infantojuvenil_anamnese_gestacao.nil? then build_infantojuvenil_anamnese_gestacao.save! end
    if infantojuvenil_anamnese_manipulacao.nil? then build_infantojuvenil_anamnese_manipulacao.save! end
    if infantojuvenil_anamnese_psicomotricidade.nil? then build_infantojuvenil_anamnese_psicomotricidade.save! end
    if infantojuvenil_anamnese_saude_historico.nil? then build_infantojuvenil_anamnese_saude_historico.save! end
    if infantojuvenil_anamnese_sexualidade.nil? then build_infantojuvenil_anamnese_sexualidade.save! end
    if infantojuvenil_anamnese_socioafetividade.nil? then build_infantojuvenil_anamnese_socioafetividade.save! end
    if infantojuvenil_anamnese_sono.nil? then build_infantojuvenil_anamnese_sono.save! end
  end

  def dados
    {
      identificação: {
        nome_completo: pessoa.nome_completo,
        data_de_nascimento: render_data_brasil(pessoa.data_nascimento),
        idade: pessoa.render_idade(data),
        sexo: pessoa.render_sexo,
        responsável_legal: "#{pessoa_responsavel&.nome_completo} #{pessoa_responsavel&.render_sexo_sigla}",
        serviço_procurado: acompanhamento.tipo.upcase,
        profissional: profissional.descricao_completa,
        data_da_consulta: data&.strftime("%d/%m/%Y"),
        motivo_da_consulta: motivo_consulta,
      },
      gestação: gestacao&.dados,
      alimentação: alimentacao&.dados,
      psicomotricidade: psicomotricidade&.dados,
      sono: sono&.dados,
      socioafetividade: socioafetividade&.dados,
      comunicação: comunicacao&.dados,
      manipulação: manipulacao&.dados,
      histórico_de_saúde: saude_historico&.dados,
      histórico_escolar: escola_historico&.dados,
      sexualidade: sexualidade&.dados,
      histórico_familiar: familia_historico&.dados,
      anotações_do_profissional: {
        hipótese_diagnóstica: diagnostico_preliminar,
        plano_de_tratamento: plano_tratamento,
        prognóstico: prognostico,
      },
    }
  end

  def itens_nao_respondidos
    dados.map { |k,v| v.map { |k,v| k if v.blank? }.compact }.flatten
  end

  def itens_respondidos
    dados.map { |k,v| v.map { |k,v| k unless v.blank? }.compact }.flatten
  end

  def dados_respondidos
    dados.map { |k,v| [k,v.map { |k,v| [k, v]}.to_h.compact] }.to_h
  end
end
