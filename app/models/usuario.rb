class Usuario < ApplicationRecord
  has_secure_password
  has_one :profissional

  belongs_to :profissional

  validates_uniqueness_of :username
  validates_presence_of :username

  scope :da_administracao, -> { where(admin: true) }
  scope :da_secretaria, -> { where(secretaria: true) }
  scope :do_corpo_clinico, -> { where(corpo_clinico: true) }
  scope :do_financeiro, -> { where(financeiro: true) }
  scope :do_ti, -> { where(informatica: true) }

  def pessoa
    profissional.pessoa
  end

  def nome_completo
    profissional.nome_completo
  end

  def nome_abreviado
    profissional.nome_abreviado
  end

  def nome_abreviado_meio
    profissional.nome_abreviado_meio
  end

  def nome_sigla
    profissional.nome_sigla
  end

  def nome_e_sobrenome
    profissional.nome_e_sobrenome
  end

  # permissoes
  def corpo_clinico?
    admin || corpo_clinico
  end

  def secretaria?
    admin || secretaria
  end

  def financeiro?
    admin || financeiro
  end

  def informatica?
    admin || informatica
  end

  def papel
    admin ? "Admin" : corpo_clinico ? "Clínico" : secretaria ? "Secretaria" : financeiro ? "Financeiro" : informatica ? "T.I." : "Quê?"
  end
end
