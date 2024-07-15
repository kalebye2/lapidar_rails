class InfantojuvenilAnamneseEscolaHistorico < ApplicationRecord
  include ApplicationHelper

  belongs_to :infantojuvenil_anamnese
  belongs_to :escola_tipo, optional: true

  self.primary_key = :infantojuvenil_anamnese_id

  def tipo_de_escola
    escola_tipo.nil? ? "Sem informação" : escola_tipo.tipo
  end

  def dados
    {
      "com quantos anos a criança entrou na escola?" => idade_entrada_anos,
      "a criança estuda em que tipo de escola?" => escola_tipo&.tipo&.upcase,
      "como é o aproveitamento escolar da criança?" => aproveitamento,
      "quais as dificuldades da criança na escola?" => dificuldades,
      "quais mudanças ocorreram no decorrer da vida escolar da criança?" => mudancas,
      "quais são as atitudes da criança frente à vida escolar?" => atitudes_paciente_vida_escolar,
      "quais as atitudes dos pais frente às dificuldades da criança?" => atitudes_pais_dificuldades,
      "como é a participação dos pais na vida escolar?" => participacao_pais,
      "de quais atividades extracurriculares a criança participa?" => atividades_extras,
      "outras considerações" => outras_consideracoes,
    }
  end
end
