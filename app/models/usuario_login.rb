class UsuarioLogin < ApplicationRecord
  belongs_to :usuario

  scope :do_periodo, -> periodo=Date.current.beginning_of_month..Date.current.end_of_month { where data: periodo }
  scope :de_hoje, -> { do_periodo Date.current }
  scope :desta_semana, -> { do_periodo Date.current.all_week }
  scope :deste_mes, -> { do_periodo Date.current.all_month }

  scope :do_usuario, -> usuario { where usuario: usuario }
  scope :do_usuario_com_id, -> id { where usuario_id: id }
end
