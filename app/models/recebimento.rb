class Recebimento < ApplicationRecord
  require "csv"

  scope :do_mes_passado, -> { where(data: (Date.today - 1.month).all_month) }
  scope :do_mes_atual, -> { where(data: Date.today.all_month) }
  scope :deste_mes, -> { do_mes_atual }

  scope :do_periodo, -> (mes: Date.today.month, ano: Date.today.year, ordem: :desc) { where("YEAR(data) = #{ano} AND MONTH(data) = #{mes}").order(data: ordem) }

  belongs_to :acompanhamento

  has_one :pessoa, through: :acompanhamento
  belongs_to :pessoa_pagante, class_name: "Pessoa", foreign_key: :pessoa_pagante_id, optional: true
  has_one :profissional, through: :acompanhamento
  #belongs_to :profissional

  belongs_to :recebimento_modalidade, foreign_key: :modalidade_id, class_name: "PagamentoModalidade"

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

  def self.para_csv(collection = all, formato_data: "%Y-%m-%d")
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
          r.profissional.pessoa.cidade,
          r.servico_prestado,
          r.modalidade
        ]
      end
    end
  end
end
