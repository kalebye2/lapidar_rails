class AtendimentoValor < ApplicationRecord
  self.primary_key = :atendimento_id

  belongs_to :atendimento, foreign_key: :atendimento_id, primary_key: :id, inverse_of: :atendimento_valor

  has_one :acompanhamento, through: :atendimento

  scope :de_atendimentos_realizados, -> { joins(:atendimento).where(atendimento: {presenca: true}) }
  scope :do_mes_atual, -> { joins(:atendimento).where("atendimentos.data" => Date.today.all_month) }
  scope :deste_mes, -> { do_mes_atual }

  scope :soma_liquidos, -> (de: Date.today.beginning_of_month, ate: Date.today.end_of_month) { joins(:atendimento).where(atendimento: { data: de.to_date..ate.to_date}).sum("valor - (valor * taxa_porcentagem_externa / 10000) - (valor * taxa_porcentagem_interna / 10000)") }
  scope :soma_liquidos_externos, -> (de: Date.today.beginning_of_month, ate: Date.today.end_of_month) { joins(:atendimento).where(atendimento: { data: de.to_date..ate.to_date}).sum("valor - (valor * taxa_porcentagem_externa / 10000)") }
  scope :soma_liquidos_internos, -> (de: Date.today.beginning_of_month, ate: Date.today.end_of_month) { joins(:atendimento).where(atendimento: { data: de.to_date..ate.to_date}).sum("valor - (valor * taxa_porcentagem_interna / 10000)") }
  scope :soma_taxas, -> (de: Date.today.beginning_of_month, ate: Date.today.end_of_month) { joins(:atendimento).where(atendimento: { data: de.to_date..ate.to_date }).sum("(valor * taxa_porcentagem_externa / 10000) + (valor * taxa_porcentagem_interna / 10000)") }
  scope :soma_taxas_externas, -> (de: Date.today.beginning_of_month, ate: Date.today.end_of_month) { joins(:atendimento).where(atendimento: { data: de.to_date..ate.to_date }).sum("valor * taxa_porcentagem_externa / 10000") }
  scope :soma_taxas_internas, -> (de: Date.today.beginning_of_month, ate: Date.today.end_of_month) { joins(:atendimento).where(atendimento: { data: de.to_date..ate.to_date }).sum("valor * taxa_porcentagem_interna / 10000") }

  def data
    atendimento.data
  end

  def horario
    atendimento.horario
  end

  def pessoa
    atendimento.acompanhamento.pessoa
  end

  def paciente
    pessoa
  end

  def profissional
    atendimento.profissional
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

  def liquido
    valor - taxa_externa - taxa_interna
  end

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
