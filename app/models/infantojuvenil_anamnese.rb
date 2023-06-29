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

  def acompanhamento
    atendimento.acompanhamento
  end

  def profissional
    acompanhamento.profissional
  end

  def pessoa
    acompanhamento.pessoa
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
end
