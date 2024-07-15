class Recebimento < ApplicationRecord
  require "csv"

  belongs_to :acompanhamento

  has_one :pessoa, through: :acompanhamento
  belongs_to :pessoa_pagante, class_name: "Pessoa", foreign_key: :pessoa_pagante_id, optional: true
  has_one :profissional, through: :acompanhamento

  belongs_to :usuario, optional: true

  # belongs_to :recebimento_modalidade, foreign_key: :modalidade_id, class_name: "PagamentoModalidade"
  belongs_to :pagamento_modalidade
  alias recebimento_modalidade pagamento_modalidade

  default_scope { includes(:acompanhamento, :pagamento_modalidade) }

  scope :do_mes, -> (mes = Date.current.all_month, ordem: :asc) { where(data: mes).order(data: ordem) }
  scope :do_mes_passado, -> { where(data: (Date.current - 1.month).all_month) }
  scope :do_mes_atual, -> { where(data: Date.current.all_month) }
  scope :deste_mes, -> { do_mes_atual }
  scope :do_ano_atual, -> { where(data: Date.current.all_year) }
  scope :deste_ano, -> { do_ano_atual }
  scope :do_ano_passado, -> { where(data: (Date.current - 1.year).all_year) }

  scope :do_periodo_alt, -> (mes: Date.current.month, ano: Date.current.year, ordem: :desc, de: nil, ate: nil) do
    if de.nil?
      where(data: ["01-#{mes}-#{ano}".to_date.."01-#{mes}-#{ano}".to_date.end_of_month]).order(data: ordem)
    else
      ate.nil? ? where(data: de).order(data: ordem) : where(data: [de..ate]).order(data: ordem)
    end
  end
  scope :do_periodo, -> (periodo=Date.current.all_month) { where(data: periodo) }

  scope :do_profissional, -> (profissional) { joins(:profissional).where(profissional: profissional) }
  scope :do_profissional_com_id, -> (id) { joins(:profissional).where(profissional: {id: id}) }

  scope :da_modalidade, -> (modalidade) { where(pagamento_modalidade: modalidade) }
  scope :da_modalidade_com_id, -> (id) { where(pagamento_modalidade_id: id) }

  scope :query_pessoa_like_nome, -> (like = "") do
    like = like.to_s
    query = "LOWER(pessoas.nome || ' ' || COALESCE(pessoas.nome_do_meio, '') || ' '|| pessoas.sobrenome) LIKE ?", "%#{like}%"
    if Rails.configuration.database_configuration[Rails.env]["adapter"].downcase == "mysql"
      query = "LOWER(CONCAT(pessoas.nome, ' ', COALESCE(pessoas.nome_do_meio, ''), ' ', pessoas.sobrenome)) LIKE ?", "%#{like}%"
    end
    joins(:pessoa).where(query)
  end
  scope :query_pagante_like_nome, -> (like = "") do
    like = like.to_s
    query = "LOWER(pagantes.nome || ' ' || COALESCE(pagantes.nome_do_meio, '') || ' '|| pagantes.sobrenome) LIKE ?", "%#{like}%"
    if Rails.configuration.database_configuration[Rails.env]["adapter"].downcase == "mysql"
      query = "LOWER(CONCAT(pagantes.nome, ' ', COALESCE(pagantes.nome_do_meio, ''), ' ', pagantes.sobrenome)) LIKE ?", "%#{like}%"
    end
    joins("JOIN pessoas AS pagantes ON recebimentos.pessoa_pagante_id = pagantes.id").where(query)
  end

  def pagante
    pessoa_pagante || pessoa
  end

  def beneficiario
    pessoa
  end

  def profissional
    acompanhamento.profissional
  end

  def modalidade
    recebimento_modalidade.modalidade
  end

  def servico_prestado
    acompanhamento.tipo
  end

  def para_linha_csv
    "#{pagante.nome_completo},#{pagante.cpf},#{beneficiario.nome_completo},#{beneficiario.cpf},#{data},#{modalidade},#{valor},#{acompanhamento.acompanhamento_tipo.tipo}" + "\n"
  end
  alias para_csv para_linha_csv

  def dados formato_data: "%d/%m/%Y", cidade_do_profissional: false
    {
      data: data.strftime(formato_data),
      valor: valor,
      beneficiário: beneficiario.nome_completo,
      cpf_beneficiario: beneficiario.render_cpf,
      pagante: pagante.nome_completo,
      cpf_pagante: pagante.render_cpf,
      profissional: profissional.nome_completo,
      registro_profissional: profissional.documento,
      cpf_profissional: profissional.pessoa.render_cpf,
      #TODO
      cidade_do_profissional: cidade_do_profissional ? profissional.pessoa.endereco_cidade : nil,
      serviço_prestado: servico_prestado,
      modalidade_de_pagamento: modalidade,
    }
  end

  def html
    
  end

  def self.para_csv(collection: all, formato_data: "%Y-%m-%d")
    CSV.generate(col_sep: ',') do |csv|
      csv << [
        "DATA",
        "VALOR",
        "BENEFICIÁRIO",
        "CPF BENEFICIÁRIO",
        "PAGANTE",
        "CPF PAGANTE",
        "PROFISSIONAL",
        "REGISTRO PROFISSIONAL",
        "CPF PROFISSIONAL",
        "CIDADE PROFISSIONAL",
        "SERVIÇO PRESTADO",
        "MODALIDADE DE PAGAMENTO"
      ]
      collection.each do |r|
        csv << [
          r.data.strftime(formato_data),
          r.valor.to_s,
          r.beneficiario.nome_completo,
          r.beneficiario.cpf,
          r.pagante.nome_completo,
          r.pagante.cpf,
          r.profissional.nome_completo,
          r.profissional.documento,
          r.profissional.pessoa.cpf,
          r.profissional.pessoa.endereco_cidade,
          r.servico_prestado,
          r.modalidade
        ]
      end
    end
  end

  def recibo_markdown
    RecebimentosController.render partial: 'show', formats: [ :md ], locals: { recebimento: self }
  end
end
