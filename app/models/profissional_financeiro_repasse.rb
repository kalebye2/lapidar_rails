class ProfissionalFinanceiroRepasse < ApplicationRecord
  belongs_to :profissional
  belongs_to :pagamento_modalidade, foreign_key: :modalidade_id
end
