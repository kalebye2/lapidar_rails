class PessoaDevolutiva < ApplicationRecord
  belongs_to :pessoa
  belongs_to :profissional
  belongs_to :responsavel, class_name: "Pessoa", foreign_key: :pessoa_responsavel_id

  scope :cronologico, -> (ordem: :asc) { order(data: ordem) }

  def informacoes_abreviadas
    p_responsavel =  (responsavel || pessoa).nome_abreviado
    "#{pessoa.nome_abreviado} (#{p_responsavel}) - #{profissional.nome_abreviado}"
  end

  def paciente
    pessoa
  end
end
