class PessoaTratamentoPronome < ApplicationRecord
  has_many :pessoa

  def default_display
    [pronome_masculino, pronome_feminino].join "/"
  end
end
