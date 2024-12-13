class AcompanhamentoReajuste < ApplicationRecord
  belongs_to :acompanhamento
  belongs_to :acompanhamento_reajuste_motivo, optional: true

  has_one :profissional, through: :acompanhamento
  has_one :pessoa, through: :acompanhamento
  alias paciente pessoa
  has_one :pessoa_responsavel, through: :acompanhamento

  before_save do
    self.valor_novo = centificar_numero(self.valor_novo)
  end

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

  def self.para_csv collection=all, col_sep: ",", formato_data: "%Y-%m-%d"
    CSV.generate(col_sep: col_sep) do |csv|
      csv << [
        "profissional",
        "paciente",
        "responsavel",
        "motivo_acompanhamento",
        "tipo_de_acompanhamento",
        "início_do_acompanhamento",
        "valor_reajuste",
        "valor_reajuste_real",
        "data_negociacao",
        "data_reajuste",
        "motivo_reajuste",
      ]

      collection.each do |reajuste|
        csv << [
          reajuste.profissional.descricao_completa,
          reajuste.pessoa.nome_completo,
          reajuste.pessoa_responsavel&.nome_completo,
          reajuste.acompanhamento.motivo,
          reajuste.acompanhamento.tipo,
          reajuste.acompanhamento.primeira_data&.strftime(formato_data),
          reajuste.valor_novo,
          reajuste.valor_novo / 100.0,
          reajuste.data_negociacao.strftime(formato_data),
          reajuste.data_ajuste.strftime(formato_data),
          reajuste.motivo,
        ]
      end
    end
  end
end
