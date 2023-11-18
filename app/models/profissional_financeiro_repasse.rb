class ProfissionalFinanceiroRepasse < ApplicationRecord
  require 'csv'
  belongs_to :profissional
  belongs_to :pagamento_modalidade, foreign_key: :modalidade_id

  scope :do_mes, -> (mes = Date.current.all_month, ordem: :asc) { where(data: mes).order(data: ordem) }
  scope :deste_mes, -> {do_mes}
  scope :do_mes_atual, -> {do_mes}
  scope :do_mes_passado, -> {do_mes((Date.current - 1.month).all_month)}
  scope :do_periodo, -> (de: Date.today.beginning_of_month, ate: Date.today.end_of_month) { where(data: de.to_date..ate.to_date).order(data: :asc) }

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
