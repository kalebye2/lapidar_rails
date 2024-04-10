class ProfissionalFinanceiroRepasse < ApplicationRecord
  require 'csv'
  belongs_to :profissional
  belongs_to :pagamento_modalidade
  belongs_to :usuario, optional: true
  alias modalidade pagamento_modalidade

  scope :do_mes, -> (mes = Date.current.all_month, ordem: :asc) { where(data: mes).order(data: ordem) }
  scope :deste_mes, -> {do_mes}
  scope :do_mes_atual, -> {do_mes}
  scope :do_mes_passado, -> {do_mes((Date.current - 1.month).all_month)}
  scope :do_periodo, -> (periodo) { where(data: periodo).order(data: :asc) }

  scope :em_ordem, -> (crescente = true) { order(data: crescente ? :asc : :desc) }

  scope :do_profissional, -> (profissional) { where(profissional: profissional) }
  scope :do_profissional_com_id, -> (id) { where(profissional_id: id) }
  scope :da_modalidade, -> (modalidade) { where(pagamento_modalidade: modalidade) }
  scope :da_modalidade_com_id, -> (id) { where(modalidade_id: id) }

  def para_linha_csv
    "#{data},#{valor},#{profissional.nome_completo},#{profissional.pessoa.cpf},#{pagamento_modalidade.modalidade}"
  end

  def self.para_csv(collection: all, formato_data: "%Y-%m-%d")
    p formato_data
    CSV.generate(col_sep: ',') do |csv|
      csv << [
        "DATA",
        "VALOR",
        "PROFISSIONAL",
        "CPF PROFISSIONAL",
        "FUNÇÃO PROFISSIONAL",
        "MODALIDADE DE PAGAMENTO",
      ]
      collection.each do |r|
        csv << [
          r.data.strftime(formato_data),
          r.valor.to_s,
          r.profissional.nome_completo,
          r.profissional.pessoa.cpf,
          r.profissional.funcao,
          r.pagamento_modalidade.modalidade,
        ]
      end
    end
  end
end
