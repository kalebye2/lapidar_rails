class InfantojuvenilAnamneseComunicacao < ApplicationRecord
  belongs_to :infantojuvenil_anamnese
  attribute :uso_eu
  attribute :entendimento
  attribute :relata_situacoes

  self.primary_key = :infantojuvenil_anamnese_id

  def dados
    {
      primeiras_sílabas: primeiras_silabas,
      primeiras_palavras: primeiras_palavras,
      primeiras_frases: primeiras_frases,
      "a criança usa o pronome \"eu\"?" => uso_eu.nil? ? "" : uso_eu > 0 ? "Sim" : "Não",
      a_criança_demonstra_que_entende_o_que_é_dito_a_ela?: entendimento.nil? ? "" : entendimento > 0 ? "Sim" : "Não",
      quais_as_atitudes_da_criança_ao_expressar_o_que_deseja?: atitudes_expressar_desejo,
      "descreva se a criança possui algum distúrbio de fala" => disturbio_fala,
      a_criança_relata_situações_que_vive?: relata_situacoes.nil? ? "" : relata_situacoes > 0 ? "Sim" : "Não",
      quais_as_línguas_ouvidas_pela_criança_em_casa?: linguas_ouvidas_casa,
      outras_considerações: outras_consideracoes,
    }
  end
end
