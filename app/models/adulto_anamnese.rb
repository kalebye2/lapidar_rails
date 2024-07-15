class AdultoAnamnese < ApplicationRecord
  belongs_to :atendimento
  has_one :acompanhamento, through: :atendimento
  has_one :pessoa, through: :acompanhamento
  has_one :profissional, through: :acompanhamento
  has_one :acompanhamento_tipo, through: :acompanhamento

  scope :do_periodo, -> (periodo=Date.current.all_month) { joins(:atendimento).where(atendimento: Atendimento.do_periodo(periodo)) }
  scope :do_profissional_com_id, -> (id) { joins(:profissional).where(profissional: Profissional.find(id)) }

  def data
    atendimento.data
  end
end
