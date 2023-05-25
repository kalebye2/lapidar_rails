# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.acronym 'RESTful'
# end
#
ActiveSupport::Inflector.inflections do |inflect|
  inflect.irregular 'profissional', 'profissionais'
  inflect.irregular 'funcao', 'funcoes'
  inflect.irregular 'subfuncao', 'subfuncoes'
  inflect.irregular 'juncao', 'juncoes'
  inflect.irregular 'especializacao', 'especializacoes'
  inflect.irregular 'regiao', 'regioes'
  inflect.irregular 'papel', 'papeis'
  inflect.irregular 'pais', 'paises'
  inflect.irregular 'nota', 'notas'
  inflect.irregular 'local', 'locais'
  inflect.irregular 'valor', 'valores'
  inflect.irregular 'especializacao', 'especializacoes'
  inflect.irregular 'alimentacao', 'alimentacoes'
  inflect.irregular 'comunicacao', 'comunicacoes'
  inflect.irregular 'gestacao', 'gestacoes'
  inflect.irregular 'manipulacao', 'manipulacoes'
  inflect.irregular 'informacao', 'informacoes'
  inflect.irregular 'responsavel', 'responsaveis'
end
