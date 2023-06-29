class AcompanhamentoView < ApplicationRecord
  belongs_to :acompanhamento, foreign_key: :id

  self.table_name = :acompanhamentos_view
end
