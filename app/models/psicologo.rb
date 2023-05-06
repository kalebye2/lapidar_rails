class Psicologo < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable
  belongs_to :civil_estado
  belongs_to :crp_regiao
  belongs_to :municipio

  # papeis
  enum papel: {admin: 0, parceiro: 1, visualizador: 2}

end
