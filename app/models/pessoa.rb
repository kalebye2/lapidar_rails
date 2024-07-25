class Pessoa < ApplicationRecord
  require "csv"
  include ApplicationHelper
  
  include Enderecavel
  include Abreviavel

  validates :nome, :sobrenome, :email, presence: true
  validates :cpf, uniqueness: true, allow_blank: true
  before_save do
    self.cpf = cpf.gsub(/\D/, '')[-11..] unless cpf.nil?
    self.fone_num = fone_num&.gsub(/\D/, '')
    self.fone_cod_pais = fone_cod_pais&.gsub(/\D/, '')
    self.fone_cod_area = fone_cod_area&.gsub(/\D/, '')
  end

  belongs_to :civil_estado, optional: true
  belongs_to :instrucao_grau, optional: true
  belongs_to :pais, optional: true
  belongs_to :pessoa_tratamento_pronome, optional: true
  belongs_to :nascimento_pais, class_name: "Pais", optional: true

  scope :do_sexo_feminino, -> { where(feminino: true) }
  scope :do_sexo_masculino, -> { where(feminino: [false, nil]) }
  scope :mulheres, -> { do_sexo_feminino }
  scope :homens, -> { do_sexo_masculino }
  scope :contagem_por_sexo, -> (collection=all) { group(:feminino).count }
  scope :profissionais, -> { joins(:profissional) }
  scope :nao_profissionais, -> do
    p_arel = self.arel_table
    pro_arel = Profissional.arel_table
    join = p_arel.join(pro_arel, Arel::Nodes::OuterJoin).on(p_arel[:id].eq(pro_arel[:pessoa_id])).join_sources
    self.joins(join).where(pro_arel[:id].eq(nil))
  end
  scope :atendidas_hoje, -> { joins(:atendimentos).where("atendimentos.data" => Date.current) }
  scope :ordem_alfabetica, -> { order(nome: :asc, nome_do_meio: :asc, sobrenome: :asc) }
  scope :em_ordem_alfabetica, -> { ordem_alfabetica }

  scope :trabalhando_na_clinica, -> { joins(:profissional) }
  scope :nao_trabalhando_na_clinica, -> { joins("LEFT JOIN profissionais ON profissionais.pessoa_id = pessoas.id").where("profissionais.id" => nil) }

  scope :de_acompanhamentos_em_andamento, -> { joins(:acompanhamentos).where(acompanhamentos: {suspenso: [nil, false, 0], acompanhamento_finalizacao_motivo: nil }).uniq }
  scope :de_acompanhamentos_finalizados, -> { joins(:acompanhamentos).where.not(acompanhamentos: {acompanhamento_finalizacao_motivo: nil}).uniq }
  scope :de_acompanhamentos_suspensos, -> { joins(:acompanhamentos).where(acompanhamentos: {suspenso: 1..}).uniq }
  
  scope :query_like_nome, -> (like = "") do
    like = like.to_s
    query = "LOWER(nome || ' ' || COALESCE(nome_do_meio, '') || ' '|| sobrenome) LIKE LOWER(?)", "%#{like}%"
    if Rails.configuration.database_configuration[Rails.env]["adapter"].downcase == "mysql"
      query = "LOWER(CONCAT(nome, ' ', COALESCE(nome_do_meio, ''), ' ', sobrenome)) LIKE LOWER(?)", "%#{like}%"
    end
    where(query)
  end

  scope :presente_na_clinica_no_periodo, -> (periodo=Date.current.all_month) { joins(:atendimentos).where(atendimentos: Atendimento.do_periodo(periodo)).distinct }

  # has associations
  # quando o cadastro for de um profissional
  has_one :profissional
  has_many :profissional_acompanhamentos, through: :profissional, source: :acompanhamentos

  # parentes
  has_many :pessoa_parentesco_juncoes
  has_many :parente_parentesco_juncoes, class_name: "PessoaParentescoJuncao", foreign_key: :parente_id
  has_many :parentes_cadastrados, through: :pessoa_parentesco_juncoes, class_name: "Pessoa", source: :parente
  has_many :parentescos, through: :pessoa_parentesco_juncoes
  has_many :parente_parentescos, through: :parente_parentesco_juncoes, source: :pessoa
  has_many :parente_de_quais_pessoas, through: :parente_parentesco_juncoes, source: :pessoa
  # registros parentais
  ParenteStruct = Struct.new(:parente, :parentesco)
  ParenteDeStruct = Struct.new(:pessoa, :parentesco)
  ParenteListaStruct = Struct.new(:parentes, :parente_de)
  ParentescoStruct = Struct.new(*self.column_names.map(&:to_sym) + [:parentesco, :origem])


  # quando o cadastro for de um paciente
  has_many :acompanhamentos
  has_many :acompanhamento_tipos, through: :acompanhamentos
  has_many :acompanhamento_horarios, through: :acompanhamentos
  has_many :acompanhamento_reajustes, through: :acompanhamentos
  has_many :atendimentos, through: :acompanhamentos
  has_many :instrumento_relatos, through: :atendimentos
  has_many :instrumentos_aplicados, through: :instrumento_relatos, source: :instrumento
  has_many :infantojuvenil_anamneses
  has_many :adulto_anamneses
  has_many :profissionais_acompanhando, class_name: "Profissional", through: :acompanhamentos, source: :profissional
  has_many :devolutivas, class_name: "PessoaDevolutiva", foreign_key: :pessoa_id
  has_many :laudos, through: :acompanhamentos

  # quando o cadastro for de um resopnsável
  has_many :acompanhamentos_responsavel, class_name: "Acompanhamento", foreign_key: :pessoa_responsavel_id
  has_many :profissionais_a_quem_responde, class_name: "Profissional", through: :acompanhamento_responsavel, source: :profissional
  has_many :responsavel_devolutivas, class_name: "PessoaDevolutiva", foreign_key: :pessoa_responsavel_id

  has_many :recebimentos, through: :acompanhamentos
  has_many :recebimentos_pagante, class_name: "Recebimento", foreign_key: :pessoa_pagante_id

  #has_many :recebimento_beneficiario_old, class_name: "Recebimento", foreign_key: :pessoa_beneficiario_id

  has_many :atendimento_valores, through: :atendimentos

  has_many :pessoa_extra_informacoes

  # medicação
  has_many :pessoa_medicacoes

  def nome_completo
    [nome, nome_do_meio, sobrenome].compact.join(' ')
  end

  def nome_abreviado_meio
    if nome_do_meio
      abreviar(nome + ' ' + nome_do_meio.to_s, '. ') + '. ' + sobrenome
    else
      abreviar(nome, '. ') + '. ' + sobrenome
    end
  end

  def nome_abreviado
    if nome_do_meio
      meio_abrev = nome_do_meio.to_s.split.map { |n| n[0] == n[0].upcase ? n[0] : '' }
      meio_sobrenome = [meio_abrev.reject(&:empty?) || meio_abrev, sobrenome].join(". ")
      [nome, meio_sobrenome].join(' ')
      nome + ' ' + [abreviar(nome_do_meio, '. '), sobrenome].join('. ')
    else
      nome + ' ' + sobrenome
    end
  end

  def nome_sigla
    abreviar([nome, nome_do_meio, sobrenome].join(' '))
  end

  def nome_e_sobrenome
    nome + ' ' + sobrenome
  end

  def render_cpf
    return nil if cpf.blank?
    cr = cpf.to_s
    # padding zeros
    cr = ("00000000000" + cr).delete(" ").chars.last(11).join("").to_s
    cr.at(0..2) + "." + cr.at(3..5) + "." + cr.at(6..8) + "-" + cr.at(-2..) 
  end

  def render_rg
    return nil if rg.blank?
    rr = rg.to_s
    rr = ("000000000" + rr).delete(" ").chars.last(9).join("").to_s
    rr.at(0..1) + "." + rr.at(2..4) + "." + rr.at(5..7) + "-" + rr.at(-1)
  end

  def tem_telefone?
    fone_cod_area && fone_num && fone_cod_pais
  end
  
  def render_fone
    tem_telefone? ?
      fr = "+" + fone_cod_pais + " (" + fone_cod_area + ") " + fone_num[..-5] + "-" + fone_num[-4..]
    :
      nil
  end

  def render_fone_local
    tem_telefone? ?
      fr = "(" + fone_cod_area + ") " + fone_num[..-5] + "-" + fone_num[-4..]
    :
      nil
  end

  def render_fone_link
    tem_telefone? ? "+#{fone_cod_pais.gsub(/\D/, "")}#{fone_cod_area.gsub(/\D/, "")}#{fone_num.gsub(/\D/, "")}" : nil
  end

  def render_whatsapp_link
    if !tem_telefone? then return nil end
    "https://wa.me/#{render_fone_link[1..]}"
  end

  def render_telegram_link
    if !tem_telefone? then return nil end
    "https://t.me/#{render_fone_link}"
  end


  def render_data_nascimento
    data_nascimento&.strftime("%d/%m/%Y")
  end

  def idade_anos(data = Time.current.to_date)
    if data_nascimento == nil then return "idade não informada" end
    if data.class.to_s != "Date" then return "" end

    dia_dif = data.day - data_nascimento.day
    mes_dif = data.month - data_nascimento.month
    ano_dif = data.year - data_nascimento.year

    mes_dif < 0 || (mes_dif == 0 && dia_dif <= 0) ? ano_dif - 1 : ano_dif
  end

  def idade_meses(data = Time.current.to_date)
    if data_nascimento == nil then return "idade não informada" end
    if data.class.to_s != "Date" then return "" end

    dia_dif = data.day - data_nascimento.day
    mes_dif = data.month - data_nascimento.month
    ano_dif = data.year - data_nascimento.year

    ano_dif * 12 + mes_dif
  end

  def render_idade(data = Time.current.to_date)
    if data_nascimento == nil then return "idade não informada" end
    if data.class.to_s != "Date" then return "" end
    hoje = data
    #hoje = Date.parse '1996-11-07'


    hoje_ano = hoje.year
    hoje_mes = hoje.month
    hoje_dia = hoje.day

    nasc_ano = data_nascimento.year
    nasc_mes = data_nascimento.month
    nasc_dia = data_nascimento.day

    # agora para os calculos
    dia_dif = hoje_dia - nasc_dia
    mes_dif = hoje_mes - nasc_mes
    ano_dif = hoje_ano - nasc_ano

    #return "#{dia_dif} #{mes_dif} #{ano_dif}"

    # nascido no mesmo ano que hoje
    if ano_dif == 0
      plural = mes_dif == 1 ? "mês" : "meses"
      return "#{hoje_mes - nasc_mes} #{plural}"
    end

    # nascido no mesmo mês que hoje
    if mes_dif == 0
      dia_me = dia_dif >= 0
      anos_idade = dia_me ? ano_dif : ano_dif - 1
      plural_anos = anos_idade == 1 ? "" : "s"
      tem_meses = !dia_me ? " e 11 meses" : ""
      return "#{anos_idade} ano#{plural_anos}#{tem_meses}"
    end

    # agora o bicho vai pegar
    meses_idade = mes_dif < 0 ? 12 + mes_dif : mes_dif
    dias_idade = dia_dif >= 0
    meses_idade = dias_idade ? meses_idade : meses_idade - 1
    anos_idade = mes_dif > 0 ? ano_dif : ano_dif - 1

    plural_anos = anos_idade == 1 ? "ano" : "anos"
    plural_meses = meses_idade == 1 ? "mês" : "meses"
    tem_meses = meses_idade > 0 ? " e #{meses_idade} #{plural_meses}" : ""

    return "#{anos_idade} #{plural_anos}#{tem_meses}"

    return "Não foi possível calcular idade"
  end


  def no_feminino?
    (feminino && !inverter_pronome_tratamento) || (!feminino && inverter_pronome_tratamento)
  end

  def no_masculino?
    !no_feminino?
  end

  def render_sexo
    if feminino then "Feminino" else "Masculino" end
  end

  def render_sexo_sigla
    if feminino then "(F)" else "(M)" end
  end

  def estado_civil
    if civil_estado.nil? then return "Sem informação" end
    sufixo = feminino ? 'a' : 'o'
    civil_estado.estado[..-2] + sufixo
  end

  def render_cep
    if endereco_cep == nil then return nil end
    if pais.nome = "Brasil" then return endereco_cep.to_s[0..-3] + '-' + endereco_cep.to_s[-3..] end
  end

  def render_endereco
    if endereco_logradouro == nil then return nil end
    num = endereco_numero || "Sem número"
    complemento = endereco_complemento || ""
    cpostal = render_cep || "Código postal não informado"
    "#{endereco_logradouro} #{num} #{endereco_complemento} - #{cpostal}"
  end

  def render_cidade_estado
    [endereco_cidade, endereco_estado].compact.join(' - ')
  end

  def nome_confidencial
    "#{nome[-2..].upcase}#{sobrenome[..2].upcase}#{nome[..1].upcase}"
  end

  def informacoes_extras
    pessoa_extra_informacoes
  end

  def atendimentos_futuros
    # depois ajusta
    atendimentos.where(data: [Date.current, Date.current + 1.day..], horario: Time.current..)
  end

  def recebimentos_beneficiario
    recebimentos
  end

  def valor_a_cobrar_ate_mes_passado
    atendimento_valores.where(atendimentos: {data: [..(Date.current - 1.month).end_of_month]}).sum("valor - desconto") - recebimentos.sum(:valor)
  end

  def valor_a_cobrar(periodo=..Date.current.end_of_month)
    (atendimento_valores.do_periodo(periodo).sum("valor - desconto") - recebimentos.do_periodo(periodo).sum(:valor)).to_i
  end

  def pronome_tratamento
    no_feminino? ? pessoa_tratamento_pronome&.pronome_feminino : pessoa_tratamento_pronome&.pronome_masculino
  end

  def pronome_tratamento_abreviado
    no_feminino? ? pessoa_tratamento_pronome.pronome_feminino_abreviado : pessoa_tratamento_pronome.pronome_masculino_abreviado
  end

  def atendimentos_a_partir_de_hoje
    atendimentos.where(data: Date.current..)
  end

  def grau_de_instrucao
    instrucao_grau&.grau
  end

  def profissao_para_clinica
    profissional&.funcao || profissao
  end

  def parente_de outro
    if outro.class.to_s != "Pessoa" then return nil end
    parentes_cadastrados.include?(outro) || parente_parentescos.include?(outro)
  end
  alias parente_de? parente_de

  def grau_parentesco outro
    if outro.class.to_s != "Pessoa" then return nil end

    parente = pessoa_parentesco_juncoes.find_by(parente_id: outro.id)
    parentesco = parente_parentesco_juncoes.find_by(pessoa_id: outro.id)

    parente_atual = parente&.parente || parentesco&.parente
    pessoa_atual = parente&.pessoa || parentesco&.pessoa

    pessoa_parentesco_juncoes.find_by(parente_id: outro.id) || parente_parentesco_juncoes.find_by(pessoa_id: outro.id)
    OpenStruct.new({ parente: parente_atual, pessoa: pessoa_atual, parentesco: parente&.parentesco&.parentesco || parentesco&.parentesco&.parentesco })
  end

  def registro_parentescos
    parentes = pessoa_parentesco_juncoes.map { |p| ParenteStruct.new(Pessoa.find(p.parente_id), Parentesco.find(p.parentesco_id).parentesco) }
    parente_de = parente_parentesco_juncoes.map { |p| ParenteDeStruct.new(Pessoa.find(p.pessoa_id), Parentesco.find(p.parentesco_id).parentesco) }
    ParenteListaStruct.new(parentes, parente_de)
  end
  alias parentescos_registrados registro_parentescos

  def registro_parentes
    regpar = registro_parentescos
    final = []
    final << regpar.parentes.map { |parente| ParentescoStruct.new(*parente.parente.attributes.values, parente.parentesco, true) }
    final << regpar.parente_de.map { |parente| ParentescoStruct.new(*parente.pessoa.attributes.values, parente.parentesco, false) }
  end
  alias parentes_registrados registro_parentes

  def contagem_registro_parentes
    rp = registro_parentes
    rp.parentes.count + rp.parente_de.count
  end

  def dados_cadastrais
    {
      nome_completo: nome_completo,
      data_de_nascimento: render_data_nascimento,
      sexo: render_sexo,
      estado_civil: estado_civil,
      grau_de_instrução: grau_de_instrucao,
      profissão: profissao,
      fone: render_fone,
      email: email,
      contatos_para_emergência: parentes_cadastrados.map { |p| "#{p.nome_completo} - #{p.render_fone}" }.join("; "),
      RG: render_rg,
      CPF: render_cpf,
      endereço: render_endereco,
      cidade: endereco_cidade,
      estado: endereco_estado,
      país: pais.nome,
      # medicação: pessoa_medicacoes.em_andamento.map { |medicacao| "#{medicacao.descricao}" }.join(", ").presence 
    }.presence || ""
  end

  def para_csv incluir_trans: false, incluir_orientacao_sexual: false
    # "\"#{nome}\"," \
    #   "\"#{nome_do_meio}\"," \
    #   "\"#{sobrenome}\"," \
    #   "\"#{render_sexo}\"," \
    #   "\"#{render_data_brasil data_nascimento}\"," \
    #   "\"#{cpf}\"," \
    #   "\"#{render_fone_link}\"," \
    #   "\"#{email}\"," \
    #   "\"#{nascimento_pais&.nome}\"," \
    #   "\"#{endereco_cep}\"," \
    #   "\"#{endereco_logradouro} nº #{endereco_numero}#{endereco_complemento&.insert(0, ' ')}\"," \
    #   "\"#{endereco_cidade}\"," \
    #   "\"#{endereco_estado}\"," \
    #   "\"#{pais&.nome}\"," \
    #   "\"#{profissao_para_clinica&.upcase}\"," \
    #   "\"#{preferencia_contato&.delete("\n", '')}\"," \
    #   "#{incluir_orientacao_sexual ? "\"#{orientacao_sexual}\"," : ""}" \
    #   "\"#{pronome_tratamento}\"," \
    #   "\"#{nome_preferido}\"" \
    #   "#{incluir_trans ? ",\"#{inverter_pronome_tratamento ? 'sim' : 'não'}\"" : ""}"

    CSV.generate(col_sep: ',') do |csv|
      csv << [
        nome,
        nome_do_meio || "-",
        sobrenome,
        render_sexo,
        data_nascimento&.strftime("%d/%m/%Y") || "-",
        render_cpf || "-",
        render_fone || "-",
        email || "-",
        nascimento_pais&.nome || "-",
        "#{endereco_logradouro}#{endereco_numero&.to_s&.insert(0, "nº ")}#{endereco_complemento&.insert(0, " ")}" || "-",
        endereco_cidade || "-",
        endereco_estado || "-",
        pais&.nome || "-",
        profissao || "-",
        preferencia_contato || "-",
        pronome_tratamento || " - ",
      ].compact
    end
  end
  alias para_linha_csv para_csv

  def self.para_csv collection=ordem_alfabetica, incluir_trans: false, incluir_orientacao_sexual: false, col_sep: ","
    # header = "nome,nome do meio,sobrenome,sexo,data de nascimento,cpf,fone,e-mail,natural de,cep,endereço,cidade,estado,país,profissão,preferência de contato,#{incluir_orientacao_sexual ? "orientação sexual," : ""}pronome de tratamento,nome preferido#{incluir_trans ? ",transexual" : ""}".upcase
    # "#{header}\n" \
    #   "#{collection.each.map {|pessoa| "#{pessoa.para_csv}"}.join("\n")}"
    CSV.generate(col_sep: col_sep) do |csv|
      csv << [
        "NOME",
        "NOME DO MEIO",
        "SOBRENOME",
        "SEXO",
        "DATA DE NASCIMENTO",
        "CPF",
        "FONE",
        "E-MAIL",
        "NATURAL DE",
        "CEP",
        "ENDEREÇO",
        "CIDADE",
        "ESTADO",
        "PAÍS",
        "PROFISSÃO",
        "PREFERÊNCIA DE CONTATO",
        "PRONOME DE TRATAMENTO",
      ]

      collection.each do |p|
        csv << [
          p.nome,
          p.nome_do_meio || "-",
          p.sobrenome,
          p.render_sexo,
          p.data_nascimento&.strftime("%d/%m/%Y") || "-",
          p.render_cpf || "-",
          p.render_fone || "-",
          p.email || "-",
          p.nascimento_pais&.nome || "-",
          p.endereco_cep,
          "#{p.endereco_logradouro} #{p.endereco_numero&.to_s&.insert(0, "nº ")} #{p.endereco_complemento&.insert(0, " ")}" || "-",
          p.endereco_cidade || "-",
          p.endereco_estado || "-",
          p.pais&.nome || "-",
          p.profissao&.upcase || "-",
          p.preferencia_contato&.upcase || "-",
          p.pronome_tratamento || " - ",
        ]
      end
    end
  end

  def self.aniversariantes
    if Rails.configuration.database_configuration[Rails.env]["adapter"].downcase.include? "sqlite"
      self.where("strftime('%d%m', data_nascimento) = strftime('%d%m', '#{Date.current}')")
    else
    end
  end

  private
  # recebimentos
end
