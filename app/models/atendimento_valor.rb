class AtendimentoValor < ApplicationRecord
  self.primary_key = :atendimento_id

  belongs_to :atendimento, foreign_key: :atendimento_id, primary_key: :id, inverse_of: :atendimento_valor

  has_one :acompanhamento, through: :atendimento
  has_one :pessoa, through: :acompanhamento
  alias paciente pessoa
  has_one :profissional, through: :acompanhamento
  has_one :pessoa_responsavel, through: :acompanhamento

  default_scope { includes(:atendimento) }

  scope :em_ordem, -> (crescente = true) { order(data: crescente ? :asc : :desc) }
  scope :de_atendimentos_realizados, -> { where(atendimento: {presenca: true}) }
  scope :de_atendimentos_nao_realizados, -> { where(atendimento: {presenca: [false, nil]}) }
  scope :do_periodo, -> (periodo = Date.current.all_month, ordem: :asc) { includes(:atendimento).where("atendimentos.data" => periodo).order("atendimentos.data" => ordem, "atendimentos.horario" => ordem) }
  scope :do_mes_atual, -> { do_periodo }
  scope :deste_mes, -> { do_mes_atual }
  scope :do_mes_passado, -> { do_periodo((Date.current - 1.month).all_month) }

  scope :soma_brutos, -> (periodo = Date.today.all_month) { joins(:atendimento).where(atendimento: {data: periodo}).sum(:valor) }
  scope :soma_liquidos, -> (periodo = Date.today.all_month) { joins(:atendimento).where(atendimento: { data: periodo}).sum("valor - (valor * taxa_porcentagem_externa / 10000) - (valor * taxa_porcentagem_interna / 10000)") }
  scope :soma_liquidos_externos, -> (periodo = Date.today.all_month) { joins(:atendimento).where(atendimento: { data: periodo}).sum("valor - (valor * taxa_porcentagem_externa / 10000)") }
  scope :soma_liquidos_internos, -> (periodo = Date.today.all_month) { joins(:atendimento).where(atendimento: { data: periodo}).sum("valor - (valor * taxa_porcentagem_interna / 10000)") }
  scope :soma_taxas, -> (periodo = Date.today.all_month) { joins(:atendimento).where(atendimento: { data: periodo }).sum("(valor * taxa_porcentagem_externa / 10000) + (valor * taxa_porcentagem_interna / 10000)") }
  scope :soma_taxas_externas, -> (periodo = Date.today.all_month) { joins(:atendimento).where(atendimento: { data: periodo }).sum("valor * taxa_porcentagem_externa / 10000") }
  scope :soma_taxas_internas, -> (periodo = Date.today.all_month) { joins(:atendimento).where(atendimento: { data: periodo }).sum("valor * taxa_porcentagem_interna / 10000") }

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
    includes(:acompanhamento).joins("JOIN pessoas AS responsaveis ON acompanhamentos.pessoa_responsavel_id = responsaveis.id").where(query)
  end

  scope :do_profissional, -> (profissional) { joins(:profissional).where(profissional: {id: profissional.id}) }
  scope :do_profissional_com_id, -> (id) { joins(:profissional).where(profissional: {id: id}) }
  scope :do_tipo_de_atendimento, -> (atendimento_tipo) { where(atendimento: {atendimento_tipo: atendimento_tipo}) }
  scope :do_tipo_de_atendimento_com_id, -> (id) { where(atendimento: {atendimento_tipo_id: id}) }

  def data
    atendimento.data_inicio_verdadeira
  end

  def horario
    atendimento.horario_inicio_verdadeiro
  end

  def atendimento_tipo
    atendimento.tipo
  end

  def taxa_externa
    valor * taxa_porcentagem_externa / 10000
  end

  def taxa_interna
    valor * taxa_porcentagem_interna / 10000
  end

  def taxa
    taxa_externa + taxa_interna
  end

  def liquido
    valor - taxa_externa - taxa_interna
  end
  alias valor_liquido liquido

  def liquido_externo
    valor - taxa_externa
  end

  def liquido_interno
    valor - taxa_interna
  end

  def self.para_csv(collection = all, formato_data: "%Y-%m-%d", formato_hora: "%H:%M")
    CSV.generate(col_sep: ',') do |csv|
      csv << [
        "DATA",
        "HORARIO",
        "PACIENTE",
        "PROFISSIONAL",
        "TIPO DE ATENDIMENTO",
        "STATUS",
        "VALOR",
        "DESCONTO",
        "TAXA EXTERNA",
        "TAXA INTERNA",
        "PLATAFORMA PARA TAXA EXTERNA",
      ]
      collection.each do |v|
        csv << [
          v.data.strftime(formato_data),
          v.horario.strftime(formato_hora),
          v.paciente.nome_completo,
          v.profissional.nome_completo,
          v.atendimento_tipo,
          v.atendimento.status,
          v.valor.to_s,
          v.desconto.to_s,
          v.valor * v.taxa_porcentagem_externa / 10000,
          v.valor * v.taxa_porcentagem_interna / 10000,
          v.acompanhamento.atendimento_plataforma.nome
        ]
      end
    end
  end
end
