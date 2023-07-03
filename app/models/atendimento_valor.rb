class AtendimentoValor < ApplicationRecord
  self.primary_key = :atendimento_id

  belongs_to :atendimento, foreign_key: :atendimento_id, primary_key: :id, inverse_of: :atendimento_valor

  has_one :acompanhamento, through: :atendimento

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
        ]
      end
    end
  end
end
