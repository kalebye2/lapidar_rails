class PessoaDevolutiva < ApplicationRecord
  belongs_to :pessoa
  alias paciente pessoa
  alias cliente pessoa
  belongs_to :profissional
  belongs_to :pessoa_interessada, class_name: "Pessoa", foreign_key: :pessoa_interessada_id, optional: true
  alias interessado pessoa_interessada
  alias responsavel pessoa_interessada
  alias pessoa_responsavel pessoa_interessada

  scope :cronologico, -> (ordem: :asc) { order(data: ordem) }
  scope :da_pessoa, -> (pessoa) { where(pessoa: pessoa) }
  scope :da_pessoa_com_id, -> (id) { where(pessoa_id: id) }
  scope :do_responsavel, -> (responsavel) { where(pessoa_responsavel: responsavel) }
  scope :do_responsavel_com_id, -> (id) { where(pessoa_responsavel_id: id) }
  scope :do_periodo, -> (periodo=Date.current.all_year) { where(data: periodo) }

  def informacoes_abreviadas
    p_responsavel =  (responsavel || pessoa).nome_abreviado
    "#{pessoa.nome_abreviado} (#{p_responsavel}) - #{profissional.nome_abreviado}"
  end

  def interessado
    pessoa_interessada || pessoa
  end

  def informacoes_por_extenso
    p_responsavel = !responsavel.nil? ? " (#{responsavel.nome_abreviado})" : ""
    "#{pessoa.nome_abreviado}#{p_responsavel} - #{data.strftime("%d/%m/%Y")} (#{profissional.descricao_completa})"
  end

  def substituir_template_por_dados atributo=""
    self[atributo]&.to_s&.gsub(/{%\s*(paciente|pessoa|cliente)\s*%}/, pessoa.nome)&.gsub(/{%\s*(responsavel|responsável|interessado|entrevistado)\s*%}/, responsavel.nome)
  end

  def dados_principais
    {
      profissional: profissional.descricao_completa,
      paciente: paciente.nome_completo,
      "interessado(a)" => pessoa_interessada&.nome_completo,
      data: data.strftime("%d/%m/%Y"),
    }.compact
  end
end
