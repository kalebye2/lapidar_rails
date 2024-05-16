class Instrumento < ApplicationRecord
  belongs_to :instrumento_tipo
  has_many :instrumento_subfuncao_juncoes
  has_many :psicologia_subfuncoes, through: :instrumento_subfuncao_juncoes
  has_many :psicologia_funcoes, through: :psicologia_subfuncoes

  scope :query_like_nome, -> (nome) { where("LOWER(nome) LIKE LOWER('%#{nome}%')") }
  scope :query_like_sigla, -> (sigla) { where("LOWER(sigla) LIKE LOWER('%#{sigla}%')") }
  scope :query_like_indicacao, -> (indicacao) { where("LOWER(indicacao) LIKE LOWER('%#{indicacao}%')") }

  scope :disponivel_na_clinica, -> { where(tem_na_clinica: true) }
  scope :nao_disponivel_na_clinica, -> { where(tem_na_clinica: [false, nil]) }

  scope :exclusivo_psicologo, -> { where exclusivo_psicologo: true }
  scope :nao_exclusivo_psicologo, -> { where exclusivo_psicologo: [false, nil] }

  scope :por_tipo, -> (instrumento_tipo) { where(instrumento_tipo: instrumento_tipo) }
  scope :por_funcao_psicologica, -> (psicologia_funcao) { joins(:psicologia_funcoes).where(psicologia_funcoes: psicologia_funcao) }
  scope :por_subfuncao_psicologica, -> (psicologia_subfuncao) { joins(:psicologia_subfuncoes).where(psicologia_subfuncoes: psicologia_subfuncao) }

  scope :em_ordem_alfabetica, -> { order(nome: :asc) }

  has_many :instrumento_relatos
  has_many :atendimentos, through: :instrumento_relatos
  has_many :acompanhamentos, through: :atendimentos
  has_many :pessoas, through: :acompanhamentos
  has_many :profissionais, through: :acompanhamentos

  def relatos
    instrumento_relatos
  end

  def tipo
    instrumento_tipo.tipo
  end

  def faixa_etaria_inicio
    if faixa_etaria_meses_inicio.nil? then return nil end
    anos = faixa_etaria_meses_inicio / 12
    meses = faixa_etaria_meses_inicio % 12
    anos = anos == 0 ? nil : "#{anos} #{anos == 1 ? 'ano' : 'anos'}"
    meses = meses == 0 ? nil : "#{meses} #{meses == 1 ? 'mês' : 'meses'}"
    [anos, meses].compact.join(' e ')
  end

  def faixa_etaria_final
    if faixa_etaria_meses_final.nil? then return nil end
    anos = faixa_etaria_meses_final / 12
    meses = faixa_etaria_meses_final % 12
    anos = anos == 0 ? nil : "#{anos} #{anos == 1 ? 'ano' : 'anos'}"
    meses = meses == 0 ? nil : "#{meses} #{meses == 1 ? 'mês' : 'meses'}"
    [anos, meses].compact.join(' e ')
  end

  def faixa_etaria sep='-'
    [faixa_etaria_inicio, faixa_etaria_final].compact.join(sep)
  end
end
