class BibliotecaObra < ApplicationRecord
  belongs_to :biblioteca_editora, optional: true, foreign_key: :editora_id
  belongs_to :biblioteca_obra_tipo, foreign_key: :obra_tipo_id
  belongs_to :biblioteca_obra, foreign_key: :periodico_id, optional: true
  has_many :biblioteca_identificadores, foreign_key: :obra_id
  has_many :biblioteca_obra_autor_juncoes, foreign_key: :obra_id
  has_many :biblioteca_autores, through: :biblioteca_obra_autor_juncoes
  has_many :biblioteca_obra_tag_juncoes, foreign_key: :obra_id
  has_many :biblioteca_tags, through: :biblioteca_obra_tag_juncoes

  scope :por_isbn, -> (val) { where("isbn LIKE '%#{val}%'") }

  def editora
    biblioteca_editora
  end

  def periodico
    biblioteca_obra
  end

  def autores
    biblioteca_autores
  end

  def autor_juncoes
    biblioteca_obra_autor_juncoes
  end

  def tags
    biblioteca_tags.order(ordem: :asc)
  end

  def tag_juncoes
    biblioteca_obra_tag_juncoes
  end

  def obra_tipo
    biblioteca_obra_tipo
  end

  def tipo
    obra_tipo.tipo.upcase
  end

  def titulo_completo
    if subtitulo.nil?
      titulo
    else
      titulo + ': ' + subtitulo
    end
  end

  def isbn_formatado
    case isbn.length
    when 13
      return "#{isbn[..2]}-#{isbn[3..4]}-#{isbn[5..8]}-#{isbn[-4..-2]}-#{isbn[-1]}"
    when 10
      return "#{isbn[0]}-#{isbn[1..5]}-#{isbn[-4..-2]}-#{isbn[-1]}"
    else
      isbn
    end
    isbn
  end

  def data_formatada
    if biblioteca_obra_tipo == BibliotecaObraTipo.find_by(tipo: "Livro")
      data_publicacao.strftime("%Y")
    else
      data_publicacao.strftime("%m/%Y")
    end
  end
  # variáveis da classe
end
