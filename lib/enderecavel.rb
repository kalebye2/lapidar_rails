module Enderecavel
  require 'uri'

  extend self

  def endereco_completo
    [endereco_logradouro, endereco_numero, endereco_bairro, endereco_cidade, endereco_estado, pais&.nome].compact.join(', ')
  end

  def endereco_completo_com_cep cep_nulo=''
    (endereco_completo.split(', ') + [endereco_cep&.to_s&.insert(0, 'CEP: ')]).compact.join(', ')
  end

  def coordenadas
    if respond_to?(:latitude) || respond_to?(:longitude)
      [latitude, longitude].compact.presence
    end
  end

  def geolink_por_coordenadas
    if respond_to?(:latitude) && respond_to?(:longitude)
      "geo:#{coordenadas&.join(', ')}"
    end
  end

  def geolink_por_endereco
  end

  def endereco_hash
    {
      logradouro: endereco_logradouro,
      número: endereco_numero,
      bairro: endereco_bairro,
      cidade: endereco_cidade,
      estado: endereco_estado,
      país: pais&.nome,
      cep: endereco_cep,
    }
  end

  def endereco_json
    endereco_hash.to_json
  end
end
