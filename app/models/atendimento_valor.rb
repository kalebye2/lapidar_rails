class AtendimentoValor < ApplicationRecord
  self.primary_key = :atendimento_id

  include Monetizavel
  extend Monetizavel

  Monetizavel.de_centavos_pra_real :valor, :desconto, :taxa_externa, :taxa_interna, :taxa_porcentagem_externa, :taxa_porcentagem_interna

  belongs_to :atendimento, foreign_key: :atendimento_id, primary_key: :id, inverse_of: :atendimento_valor

  has_one :acompanhamento, through: :atendimento
  has_one :pessoa, through: :acompanhamento
  alias paciente pessoa
  has_one :profissional, through: :acompanhamento
  has_one :pessoa_responsavel, through: :acompanhamento

  default_scope { includes(:atendimento) }

  before_save do
    # final_valor = self.valor&.to_s || "0,00"
    # if !final_valor.include?(",")
    #   final_valor += ","
    # end
    # index_virgula = final_valor.index(",")
    # valor_inteiros = final_valor[..index_virgula - 1]
    # valor_decimais = ((final_valor[index_virgula + 1..]) + "00")[..1]
    # self.valor = "#{valor_inteiros}#{valor_decimais}".gsub(",", "").to_i

#     mudar = {
#       valor: self.valor,
#       desconto: self.desconto,
#       taxa_porcentagem_externa: self.taxa_porcentagem_externa,
#       taxa_porcentagem_interna: self.taxa_porcentagem_interna,
#     }
#     mudar = mudar.map { |k,v|
#       final_valor = v&.to_s || "0,00"
#       if !final_valor.include?(",")
#         final_valor += ","
#       end
#       final_valor.gsub!(".", "")
#       index_virgula = final_valor.index(",")
#       valor_inteiros = final_valor[..index_virgula - 1]
#       valor_decimais = ((final_valor[index_virgula + 1..]) + "00")[..1]
#       [k, "#{valor_inteiros}#{valor_decimais}".gsub(",", "").to_i]
#     }.to_h
#     self.valor = mudar[:valor] if self.valor_changed?
#     self.desconto = mudar[:desconto] if self.desconto_changed?
#     self.taxa_porcentagem_externa = mudar[:taxa_porcentagem_externa] if self.taxa_porcentagem_externa_changed?
#     self.taxa_porcentagem_interna = mudar[:taxa_porcentagem_interna] if self.taxa_porcentagem_interna_changed?
  end

  scope :em_ordem, -> (crescente = true) { order("atendimentos.data" => crescente ? :asc : :desc) }
  scope :de_atendimentos_realizados, -> { where(atendimento: {presenca: true}) }
  scope :de_atendimentos_nao_realizados, -> { where(atendimento: {presenca: [false, nil]}) }
  scope :do_periodo, -> (periodo = Date.current.all_month) { joins(:atendimento).where(atendimento: Atendimento.do_periodo(periodo)) }
  scope :do_mes_atual, -> { do_periodo }
  scope :deste_mes, -> { do_mes_atual }
  scope :do_mes_passado, -> { do_periodo((Date.current - 1.month).all_month) }
  scope :do_ano_atual, -> { do_periodo(Date.current.all_year) }
  scope :deste_ano, -> { do_ano_atual }
  scope :do_ano_passado, -> { do_periodo((Date.current - 1.year).all_year) }
  scope :da_semana_atual, -> { do_periodo(Date.current.all_week) }
  scope :da_semana_passada, -> { do_periodo((Date.current - 1.week).all_week) }
  scope :de_hoje, -> { do_periodo(Date.current) }
  scope :de_ontem, -> { do_periodo(Date.current - 1.day) }
  scope :ate_ontem, -> { do_periodo(..Date.current - 1.day) }
  scope :ate_hoje, -> { do_periodo(..Date.current) }

  scope :agrupar_por_profissional_id_e_data, -> { joins(:acompanhamento).group(:profissional_id, "atendimentos.data") }

  scope :soma_brutos, -> () { sum(:valor) }
  scope :soma_liquidos, -> () { sum("valor - (valor * taxa_porcentagem_externa / 10000) - (valor * taxa_porcentagem_interna / 10000)") }
  scope :soma_liquidos_externos, -> () { sum("valor - (valor * taxa_porcentagem_externa / 10000)") }
  scope :soma_liquidos_internos, -> () { sum("valor - (valor * taxa_porcentagem_interna / 10000)") }
  scope :soma_taxas, -> () { sum("(valor * taxa_porcentagem_externa / 10000) + (valor * taxa_porcentagem_interna / 10000)") }
  scope :soma_taxas_externas, -> () { sum("valor * taxa_porcentagem_externa / 10000") }
  scope :soma_taxas_internas, -> () { sum("valor * taxa_porcentagem_interna / 10000") }

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

  scope :soma_brutos_por_dia, -> { joins(:atendimento).group("atendimentos.data").soma_brutos }
  scope :soma_liquidos_por_dia, -> { joins(:atendimento).group("atendimentos.data").soma_liquidos }
  scope :soma_liquidos_externos_por_dia, -> () { joins(:atendimento).group("atendimentos.data").soma_liquidos_externos }
  scope :soma_liquidos_internos_por_dia, -> () { joins(:atendimento).group("atendimentos.data").soma_liquidos_internos }
  scope :soma_taxas_por_dia, -> () { joins(:atendimento).group("atendimentos.data").soma_taxas }
  scope :soma_taxas_externas_por_dia, -> () { joins(:atendimento).group("atendimentos.data").soma_taxas_externas }
  scope :soma_taxas_internas_por_dia, -> () { joins(:atendimento).group("atendimentos.data").soma_taxas_internas }
  scope :soma_brutos_por_mes, -> { joins(:atendimento).group("atendimentos.data").soma_brutos.group_by { |k,v| k.strftime("%m/%Y") }.map { |k,v| [k.to_date.all_month, v.map(&:last).sum] }.to_h }
  scope :soma_liquidos_por_mes, -> { joins(:atendimento).group("atendimentos.data").soma_liquidos.group_by { |k,v| k.strftime("%m/%Y") }.map { |k,v| [k.to_date.all_month, v.map(&:last).sum] }.to_h  }
  scope :soma_liquidos_externos_por_mes, -> () { joins(:atendimento).group("atendimentos.data").soma_liquidos_externos.group_by { |k,v| k.strftime("%m/%Y") }.map { |k,v| [k.to_date.all_month, v.map(&:last).sum] }.to_h  }
  scope :soma_liquidos_internos_por_mes, -> () { joins(:atendimento).group("atendimentos.data").soma_liquidos_internos.group_by { |k,v| k.strftime("%m/%Y") }.map { |k,v| [k.to_date.all_month, v.map(&:last).sum] }.to_h  }
  scope :soma_taxas_por_mes, -> () { joins(:atendimento).group("atendimentos.data").soma_taxas.group_by { |k,v| k.strftime("%m/%Y") }.map { |k,v| [k.to_date.all_month, v.map(&:last).sum] }.to_h  }
  scope :soma_taxas_externas_por_mes, -> () { joins(:atendimento).group("atendimentos.data").soma_taxas_externas.group_by { |k,v| k.strftime("%m/%Y") }.map { |k,v| [k.to_date.all_month, v.map(&:last).sum] }.to_h  }
  scope :soma_taxas_internas_por_mes, -> () { joins(:atendimento).group("atendimentos.data").soma_taxas_internas.group_by { |k,v| k.strftime("%m/%Y") }.map { |k,v| [k.to_date.all_month, v.map(&:last).sum] }.to_h  }


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
    valor - desconto - taxa_externa - taxa_interna
  end
  alias valor_liquido liquido

  def liquido_externo
    valor - desconto - taxa_externa
  end

  def liquido_interno
    valor - desconto - taxa_interna
  end

  %i[ liquido liquido_externo liquido_interno ].each do |method_name|
    define_method "#{method_name}_real" do
      self.send(method_name) / 100.0
    end

    define_singleton_method method_name do |collection=all|
      collection.map { |element| element.send(method_name) }.sum
    end

    define_singleton_method "#{method_name}_real" do
      all.map { |element| element.send(method_name) }.sum / 100.0
    end
  end

  def self.para_csv(collection = all, formato_data: "%Y-%m-%d", formato_hora: "%H:%M", col_sep: ",")
    CSV.generate(col_sep: col_sep) do |csv|
      csv << [
        "data",
        "horario",
        "paciente",
        "profissional",
        "tipo_de_atendimento",
        "status",
        "valor",
        "valor_real",
        "desconto",
        "desconto_real",
        "taxa_externa",
        "taxa_externa_real",
        "taxa_interna",
        "taxa_interna_real",
        "liquido",
        "liquido_real",
        "plataforma_taxa_externa",
      ]
      collection.each do |v|
        csv << [
          v.data.strftime(formato_data),
          v.horario.strftime(formato_hora),
          v.paciente.nome_social_completo,
          v.profissional.nome_social_completo,
          v.atendimento_tipo,
          v.atendimento.status,
          v.valor.to_s,
          v.valor / 100.0,
          v.desconto.to_s,
          v.desconto / 100.0,
          v.valor * v.taxa_porcentagem_externa / 10000,
          v.valor * v.taxa_porcentagem_externa / 10000 / 100.0,
          v.valor * v.taxa_porcentagem_interna / 10000,
          v.valor * v.taxa_porcentagem_interna / 10000 / 100.0,
          v.liquido,
          v.liquido / 100.0,
          v.acompanhamento.atendimento_plataforma.nome
        ]
      end
    end
  end

  def self.para_tsv(collection = all, formato_data: "%Y-%m-%d", formato_hora: "%H:%M", col_sep: "\t")
    CSV.generate(col_sep: col_sep) do |csv|
      csv << [
        "data",
        "horario",
        "paciente",
        "profissional",
        "tipo_de_atendimento",
        "status",
        "valor",
        "valor_real",
        "desconto",
        "desconto_real",
        "taxa_externa",
        "taxa_externa_real",
        "taxa_interna",
        "taxa_interna_real",
        "liquido",
        "liquido_real",
        "plataforma_taxa_externa",
      ]
      collection.each do |v|
        csv << [
          v.data.strftime(formato_data),
          v.horario.strftime(formato_hora),
          v.paciente.nome_social_completo,
          v.profissional.nome_social_completo,
          v.atendimento_tipo,
          v.atendimento.status,
          v.valor.to_s,
          v.valor / 100.0,
          v.desconto.to_s,
          v.desconto / 100.0,
          v.valor * v.taxa_porcentagem_externa / 10000,
          v.valor * v.taxa_porcentagem_externa / 10000 / 100.0,
          v.valor * v.taxa_porcentagem_interna / 10000,
          v.valor * v.taxa_porcentagem_interna / 10000 / 100.0,
          v.liquido,
          v.liquido / 100.0,
          v.acompanhamento.atendimento_plataforma.nome
        ]
      end
    end
  end
end
