# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#

civil_estados = CivilEstado.create([
  { estado: 'solteiro' },
  { estado: 'casado' },
  { estado: 'viúvo' },
  { estado: 'divorciado' }
])

Uf.create([
  {
    :id => 0,
    :nome => "nenhum",
    :sigla => "NA"
  },
  {
    :nome => "Acre",
    :sigla => "AC"
  },
  {
    :nome => "Alagoas",
    :sigla => "AL"
  },
  {
    :nome => "Amapá",
    :sigla => "AP"
  },
  {
    :nome => "Amazonas",
    :sigla => "AM"
  },
  {
    :nome => "Bahia",
    :sigla => "BA"
  },
  {
    :nome => "Ceará",
    :sigla => "CE"
  },
  {
    :nome => "Distrito Federal",
    :sigla => "DF"
  },
  {
    :nome => "Espírito Santo",
    :sigla => "ES"
  },
  {
    :nome => "Goiás",
    :sigla => "GO"
  },
  {
    :nome => "Maranhão",
    :sigla => "MA"
  },
  {
    :nome => "Mato Grosso",
    :sigla => "MT"
  },
  {
    :nome => "Mato Grosso do Sul",
    :sigla => "MS"
  },
  {
    :nome => "Minas Gerais",
    :sigla => "MG"
  },
  {
    :nome => "Pará",
    :sigla => "PA"
  },
  {
    :nome => "Paraíba",
    :sigla => "PB"
  },
  {
    :nome => "Paraná",
    :sigla => "PR"
  },
  {
    :nome => "Pernambuco",
    :sigla => "PE"
  },
  {
    :nome => "Piauí",
    :sigla => "PI"
  },
  {
    :nome => "Rio de Janeiro",
    :sigla => "RJ"
  },
  {
    :nome => "Rio Grande do Norte",
    :sigla => "RN"
  },
  {
    :nome => "Rio Grande do Sul",
    :sigla => "RS"
  },
  {
    :nome => "Rondônia",
    :sigla => "RO"
  },
  {
    :nome => "Roraima",
    :sigla => "RR"
  },
  {
    :nome => "Santa Catarina",
    :sigla => "SC"
  },
  {
    :nome => "São Paulo",
    :sigla => "SP"
  },
  {
    :nome => "Sergipe",
    :sigla => "SE"
  },
  {
    :nome => "Tocantins",
    :sigla => "TO"
  },
])

Municipio.create([
  {
    :id => 0,
    :nome => "nenhum",
    :uf_id => 0
  }
])

CrpRegiao.create([
  :id => 0,
  :uf_id => 0
])
