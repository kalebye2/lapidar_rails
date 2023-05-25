class Pessoa < ApplicationRecord
  belongs_to :civil_estado
  belongs_to :instrucao_grau
  belongs_to :pais
  
  # has associations
  has_one :usuario
  has_one :profissional


  def render_cpf
    cr = cpf.to_s
    # padding zeros
    cr = ("00000000000" + cr).delete(" ").chars.last(11).join("").to_s
    cr.at(0..2) + "." + cr.at(3..5) + "." + cr.at(6..8) + "-" + cr.at(-2..) 
  end

  def render_fone
    fr = "+" + fone_cod_pais + " (" + fone_cod_area + ") " + fone_num[..-5] + "-" + fone_num[-4..]
  end

  def render_fone_link
    "+#{fone_cod_pais}#{fone_cod_area}#{fone_num}"
  end


  def render_data_nascimento
    data_nascimento.strftime("%d/%m/%Y")
  end

  def render_idade
    if data_nascimento == nil then return "idade não informada" end
    hoje = Time.now.to_date
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

end
