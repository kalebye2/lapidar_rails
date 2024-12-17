class Laudo < ApplicationRecord
  belongs_to :acompanhamento
  has_one :pessoa, through: :acompanhamento
  has_one :profissional, through: :acompanhamento
  has_many :instrumentos_aplicados, through: :acompanhamento

  scope :fechados, -> { where(fechado: true) }
  scope :abertos, -> { where(fechado: [false, nil]) }

  scope :query_pessoa_like_nome, -> (like = "") do
    like = like.to_s
    query = "LOWER(pessoas.nome || ' ' || COALESCE(pessoas.nome_do_meio, '') || ' '|| pessoas.sobrenome) LIKE ?", "%#{like}%"
    if Rails.configuration.database_configuration[Rails.env]["adapter"].downcase == "mysql"
      query = "LOWER(CONCAT(pessoas.nome, ' ', COALESCE(pessoas.nome_do_meio, ''), ' ', pessoas.sobrenome)) LIKE ?", "%#{like}%"
    end
    joins(:pessoa).where(query)
  end

  scope :query_interessado_like_nome, -> (like = "") do
    like = like.downcase
    where("LOWER(interessado) LIKE '%#{like}%'")
  end

  def paciente
    pessoa
  end

  def parte_interessada
    interessado || pessoa.nome_completo
  end

  def data_inicial
    data_inicio_avaliacao || acompanhamento.data_inicio
  end

  def data_final
    data_final_avaliacao || data_avaliacao
  end

  def numero_de_sessoes
    acompanhamento.numero_de_sessoes(inicio: data_inicial, final: data_final)
  end
  alias num_sessoes numero_de_sessoes

  def dias_de_avaliacao
    (data_final - data_inicial).to_i
  end

  def render_titulo
    acompanhamento.tipo&.upcase
  end

  def instrumentos_usados
    acompanhamento.instrumentos_aplicados
  end

  def substituir_template_por_dados atributo=""
    self[atributo]&.to_s&.gsub(/{%\s*(paciente|pessoa|cliente)\s*%}/, pessoa.nome)
  end

  def texto_completo format: :markdown, base_heading_level: 1, incluir_instrumentos: true
    hmarker = "#" * base_heading_level
    if instrumentos_usados.count > 0
      instrumentos_inclusos = "#{hmarker} Instrumentos usados\n\n" \
        "#{instrumentos_usados.map { |i| "- #{i.nome}" }.join("\n")}"
    end

    if format == (:markdown || :md)
      "#{hmarker} Demanda\n\n" \
        "#{substituir_template_por_dados :demanda}\n\n" \
        "#{incluir_instrumentos ? "#{instrumentos_inclusos}\n\n" : ""}" \
        "#{hmarker} Técnicas utilizadas\n\n" \
        "#{substituir_template_por_dados :tecnicas}\n\n" \
        "#{hmarker} Análise\n\n" \
        "#{substituir_template_por_dados :analise}\n\n" \
        "#{hmarker} Conclusão\n\n" \
        "#{substituir_template_por_dados :conclusao}\n\n" \
        "#{referencias.presence ? "#{hmarker} Referências\n\n#{referencias}" : ""}"
    end
  end
end
