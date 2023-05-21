class UsuarioDevolutiva < ApplicationRecord
  belongs_to :usuario
  belongs_to :profissional
end
