class BibliotecaAutor < ApplicationRecord
  has_many :biblioteca_obra_autor_juncoes, foreign_key: :autor_id
  has_many :biblioteca_obras, through: :biblioteca_obra_autor_juncoes
  has_many :biblioteca_tags, through: :biblioteca_obra

  def obras
    biblioteca_obras
  end

  def obra_juncoes
    biblioteca_obra_autor_juncoes
  end

  def tags
    biblioteca_tags
  end

  def nome_completo
    "#{(nome.nil? || nome.empty?) ? '' : nome}#{(nome_do_meio.nil? || nome_do_meio.empty?) ? ' ' : ' ' + nome_do_meio + ' '}#{sobrenome}"
  end

  def nome_referencia
    "#{sobrenome}#{(nome.nil? || nome.empty?) ? '' : ', ' + nome}#{(nome_do_meio.nil? || nome_do_meio.empty?) ? '' : ' ' + nome_do_meio}"
  end
end
