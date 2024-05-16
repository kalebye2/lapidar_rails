class AcompanhamentoReajuste < ApplicationRecord
  belongs_to :acompanhamento
  belongs_to :acompanhamento_reajuste_motivo, optional: true

  has_one :profissional, through: :acompanhamento
  has_one :pessoa, through: :acompanhamento
  has_one :pessoa_responsavel, through: :acompanhamento

  scope :ajustes_futuros, -> { where(data_ajuste: Date.current..) }
  scope :negociacoes_futuras, -> { where(data_negociacao: Date.current..) }
  scope :nao_aplicados, -> { where(id: map{ |acompanhamento_reajuste| if acompanhamento_reajuste.valor_novo != acompanhamento_reajuste.acompanhamento.valor_sessao then acompanhamento_reajuste.id end }.compact) }
  scope :ajustes_no_periodo, -> (periodo) { where(data_ajuste: periodo) }
  scope :negociacoes_no_periodo, -> (periodo) { where(data_negociacao: periodo) }

  scope :do_profissional, -> (profissional) { joins(:profissional).where(acompanhamento: {profissional: profissional}) }
  scope :do_profissional_com_id, -> (id) { joins(:profissional).where(profissional: {id: id}) }
  scope :da_pessoa, -> (pessoa) { joins(:pessoa).where(acompanhamento: {pessoa: pessoa}) }
  scope :da_pessoa_com_id, -> (id) { joins(:pessoa).where(pessoa: {id: id}) }

  accepts_nested_attributes_for :acompanhamento

  def motivo
    acompanhamento_reajuste_motivo&.motivo
  end
  alias motivo_do_reajuste motivo
end
