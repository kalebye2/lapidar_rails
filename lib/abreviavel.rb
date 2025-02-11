module Abreviavel
  extend self

  def abreviar string, separator = ''
    string = string.to_s
    str_abreviar = string.split.map { |n| n[0] == n[0].upcase ? n[0] : ''}
    str_abreviar = str_abreviar.reject!(&:empty?) || str_abreviar
    str_abreviar.join(separator) + separator.gsub(/\s*$/, "") if str_abreviar.presence
  end
end
