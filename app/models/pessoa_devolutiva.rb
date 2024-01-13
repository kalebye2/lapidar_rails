class PessoaDevolutiva < ApplicationRecord
  belongs_to :pessoa
  alias paciente pessoa
  belongs_to :profissional
  belongs_to :responsavel, class_name: "Pessoa", foreign_key: :pessoa_responsavel_id

  scope :cronologico, -> (ordem: :asc) { order(data: ordem) }

  def informacoes_abreviadas
    p_responsavel =  (responsavel || pessoa).nome_abreviado
    "#{pessoa.nome_abreviado} (#{p_responsavel}) - #{profissional.nome_abreviado}"
  end

  def informacoes_por_extenso
    p_responsavel = !responsavel.nil? ? " (#{responsavel.nome_abreviado})" : ""
    "#{pessoa.nome_abreviado}#{p_responsavel} - #{data.strftime("%d/%m/%Y")} (#{profissional.descricao_completa})"
  end

  def substituir_template_por_dados atributo=""
    self[atributo]&.to_s&.gsub(/{%\s*(paciente|pessoa|cliente)\s*%}/, pessoa.nome)&.gsub(/{%\s*(responsavel|responsável|interessado|entrevistado)\s*%}/, responsavel.nome)
  end

end
