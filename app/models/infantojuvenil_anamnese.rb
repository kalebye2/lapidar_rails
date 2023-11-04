class InfantojuvenilAnamnese < ApplicationRecord
  has_one :infantojuvenil_anamnese_alimentacao
  has_one :infantojuvenil_anamnese_comunicacao
  has_one :infantojuvenil_anamnese_escola_historico
  has_one :infantojuvenil_anamnese_familia_historico
  has_one :infantojuvenil_anamnese_gestacao
  has_one :infantojuvenil_anamnese_manipulacao
  has_one :infantojuvenil_anamnese_psicomotricidade
  has_one :infantojuvenil_anamnese_saude_historico
  has_one :infantojuvenil_anamnese_sexualidade
  has_one :infantojuvenil_anamnese_socioafetividade
  has_one :infantojuvenil_anamnese_sono

  belongs_to :atendimento
  has_one :acompanhamento, through: :atendimento
  has_one :pessoa, through: :acompanhamento
  has_one :profissional, through: :acompanhamento
  has_one :pessoa_responsavel, through: :acompanhamento

  accepts_nested_attributes_for :infantojuvenil_anamnese_gestacao
  accepts_nested_attributes_for :pessoa

  belongs_to :atendimento

  def acompanhamento
    atendimento.acompanhamento
  end

  def profissional
    acompanhamento.profissional
  end

  def pessoa
    acompanhamento.pessoa
  end

  def paciente
    pessoa
  end

  def pessoa_responsavel
    acompanhamento.pessoa_responsavel
  end

  #
  def alimentacao
    infantojuvenil_anamnese_alimentacao
  end

  def comunicacao
    infantojuvenil_anamnese_comunicacao
  end

  def escola_historico
    infantojuvenil_anamnese_escola_historico
  end

  def familia_historico
    infantojuvenil_anamnese_familia_historico
  end

  def gestacao
    infantojuvenil_anamnese_gestacao
  end

  def manipulacao
    infantojuvenil_anamnese_manipulacao
  end

  def psicomotricidade
    infantojuvenil_anamnese_psicomotricidade
  end

  def saude_historico
    infantojuvenil_anamnese_saude_historico
  end

  def sexualidade
    infantojuvenil_anamnese_sexualidade
  end

  def socioafetividade
    infantojuvenil_anamnese_socioafetividade
  end
  
  def sono
    infantojuvenil_anamnese_sono
  end

  def criar_anamnese_completa
    if infantojuvenil_anamnese_alimentacao.nil? then build_infantojuvenil_anamnese_alimentacao.save! end
    if infantojuvenil_anamnese_comunicacao.nil? then build_infantojuvenil_anamnese_comunicacao.save! end
    if infantojuvenil_anamnese_escola_historico.nil? then build_infantojuvenil_anamnese_escola_historico.save! end
    if infantojuvenil_anamnese_familia_historico.nil? then build_infantojuvenil_anamnese_familia_historico.save! end
    if infantojuvenil_anamnese_gestacao.nil? then build_infantojuvenil_anamnese_gestacao.save! end
    if infantojuvenil_anamnese_manipulacao.nil? then build_infantojuvenil_anamnese_manipulacao.save! end
    if infantojuvenil_anamnese_psicomotricidade.nil? then build_infantojuvenil_anamnese_psicomotricidade.save! end
    if infantojuvenil_anamnese_saude_historico.nil? then build_infantojuvenil_anamnese_saude_historico.save! end
    if infantojuvenil_anamnese_sexualidade.nil? then build_infantojuvenil_anamnese_sexualidade.save! end
    if infantojuvenil_anamnese_socioafetividade.nil? then build_infantojuvenil_anamnese_socioafetividade.save! end
    if infantojuvenil_anamnese_sono.nil? then build_infantojuvenil_anamnese_sono.save! end
  end



end
