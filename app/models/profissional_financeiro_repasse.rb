class ProfissionalFinanceiroRepasse < ApplicationRecord
  belongs_to :profissional
  belongs_to :pagamento_modalidade, foreign_key: :modalidade_id

  scope :do_mes, -> (mes = Date.current.all_month, ordem: :asc) { where(data: mes).order(data: ordem) }
end
