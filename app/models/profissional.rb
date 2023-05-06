class Profissional < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable
  belongs_to :civil_estado
  belongs_to :instrucao_grau
  belongs_to :funcao
  belongs_to :municipio
end
