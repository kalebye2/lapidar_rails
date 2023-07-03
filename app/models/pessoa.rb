class Pessoa < ApplicationRecord
  belongs_to :civil_estado, optional: true
  belongs_to :instrucao_grau, optional: true
  belongs_to :pais, optional: true
  belongs_to :pessoa_tratamento_pronome, optional: true
  
  # has associations
  has_one :usuario
  # quando o cadastro for de um profissional
  has_one :profissional
  has_many :profissional_acompanhamento, through: :profissional, source: :acompanhamento

  # quando o cadastro for de um paciente
  has_many :acompanhamentos
  has_many :atendimentos, through: :acompanhamentos
  has_many :instrumento_relatos, through: :atendimentos
  has_many :instrumentos_aplicados, through: :instrumento_relatos, source: :instrumento
  has_many :profissionais_acompanhando, class_name: "Profissional", through: :acompanhamento, source: :profissional
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

  has_many :pessoa_extra_informacao



  def nome_completo
    if !nome_do_meio.nil?
      [nome, nome_do_meio, sobrenome].join(' ')
    else
      [nome, sobrenome].join(' ')
    end
  end

  def nome_abreviado_meio
    #nome_abrev = (nome + ' ' + nome_do_meio).split.map { |n| n[0] == n[0].upcase ? n[0] : '' }
    #nome_abrev = abreviar(nome + ' ' + nome_do_meio, '. ')
    #[nome_abrev.reject(&:empty?) || nome_abrev, sobrenome].join('. ')
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
    cr = cpf.to_s
    # padding zeros
    cr = ("00000000000" + cr).delete(" ").chars.last(11).join("").to_s
    cr.at(0..2) + "." + cr.at(3..5) + "." + cr.at(6..8) + "-" + cr.at(-2..) 
  end

  def tem_telefone
    fone_cod_area && fone_num && fone_cod_pais
  end
  
  def render_fone
    tem_telefone ?
      fr = "+" + fone_cod_pais + " (" + fone_cod_area + ") " + fone_num[..-5] + "-" + fone_num[-4..]
    :
      nil
  end

  def render_fone_link
    "+#{fone_cod_pais}#{fone_cod_area}#{fone_num}"
  end


  def render_data_nascimento
    data_nascimento.strftime("%d/%m/%Y")
  end

  def render_idade(data = Time.now.to_date)
    if data_nascimento == nil then return "idade não informada" end
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


  def render_sexo
    if feminino then "Feminino" else "Masculino" end
  end

  def render_sexo_sigla
    if feminino then "(F)" else "(M)" end
  end

  def estado_civil
    sufixo = feminino ? 'a' : 'o'
    civil_estado.estado[..-2] + sufixo
  end

  def render_cep
    if endereco_cep == nil then return nil end
    if pais.nome = "Brasil" then return endereco_cep.to_s[0..-3] + '-' + endereco_cep.to_s[-3..] end
  end

  def render_endereco
    if endereco_logradouro == nil then return "Endereço não informado" end
    num = endereco_numero || "Sem número"
    complemento = endereco_complemento || ""
    cpostal = render_cep || "Código postal não informado"
    "#{endereco_logradouro} #{num} #{endereco_complemento} - #{cpostal}"
  end

  def render_cidade_estado
    c = cidade || "Não informado"
    e = estado || "Não informado"
    "#{c} - #{e}"
  end

  def nome_relato
    "#{nome[-2..].upcase}#{sobrenome[..2].upcase}#{nome[..1].upcase}"
  end

  def informacoes_extras
    pessoa_extra_informacao
  end

  def atendimentos_futuros
    atendimentos.where("DATEDIFF(data, CURRENT_DATE) > 0 OR (DATEDIFF(data, CURRENT_DATE) = 0 AND HOUR(horario) > HOUR(CURRENT_TIME))")
  end

  def recebimentos_beneficiario
    recebimentos
  end

  def valor_a_cobrar_ate_mes_passado
    atendimento_valores.where(atendimentos: {data: [..(Date.today - 1.month).end_of_month]}).sum("valor - desconto") - recebimentos.sum(:valor)
  end

  def pronome_tratamento
    pronome_no_feminino = (feminino && !inverter_pronome_tratamento) || (!feminino && inverter_pronome_tratamento)
    pronome_no_feminino ? pessoa_tratamento_pronome.pronome_feminino : pessoa_tratamento_pronome.pronome_masculino
  end

  def pronome_tratamento_abreviado
  end

  private

  def abreviar string, separator = ''
    string = string.to_s
    str_abreviar = string.split.map { |n| n[0] == n[0].upcase ? n[0] : ''}
    str_abreviar = str_abreviar.reject!(&:empty?) || str_abreviar
    str_abreviar.join(separator)
  end


  # recebimentos
  def valor_a_cobrar
    atendimento_valores.sum("valor - desconto") - recebimento.sum(:valor)
  end
end
