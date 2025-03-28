class Profissional < ApplicationRecord
  belongs_to :pessoa
  belongs_to :profissional_funcao

  has_one :usuario
  has_many :usuario_logins, through: :usuario

  has_many :profissional_especializacao_juncoes, foreign_key: :profissional_id
  has_many :profissional_especializacoes, through: :profissional_especializacao_juncoes
  alias especializacoes profissional_especializacoes

  has_many :profissional_horarios
  accepts_nested_attributes_for :profissional_horarios

  has_many :acompanhamentos
  has_many :acompanhamento_tipos, through: :profissional_funcao
  has_many :acompanhamento_horarios, through: :acompanhamentos
  has_many :acompanhamento_reajustes, through: :acompanhamentos
  has_many :pacientes, through: :acompanhamentos, source: :pessoa
  has_many :responsaveis_por_pacientes, through: :acompanhamentos, source: :pessoa_responsavel
  has_many :atendimentos, through: :acompanhamentos
  has_many :recebimentos, through: :acompanhamentos
  has_many :laudos, through: :acompanhamentos
  has_many :atendimento_valores, through: :atendimentos
  has_many :atendimento_locais, through: :atendimentos
  has_many :repasses, class_name: "ProfissionalFinanceiroRepasse"
  alias profissional_financeiro_repasses repasses
  has_many :instrumento_relatos, through: :atendimentos
  has_many :instrumentos_que_aplicou, through: :instrumento_relatos, source: :instrumento
  alias instrumentos_aplicados instrumentos_que_aplicou
  has_many :pessoa_devolutivas

  has_many :profissional_documento_modelos
  has_many :profissional_contrato_modelos
  alias contrato_modelos profissional_contrato_modelos
  alias modelos_de_contrato profissional_contrato_modelos

  has_many :profissional_especializacao_juncoes
  has_many :profissional_especializacoes, through: :profissional_especializacao_juncoes

  has_many :profissional_folgas

  scope :ordem_alfabetica, -> { includes(:pessoa).order("pessoas.nome" => :asc, "pessoas.nome_do_meio" => :asc, "pessoas.sobrenome" => :asc) }
  scope :com_atendimentos_futuros, -> { includes(:atendimentos).where("atendimentos.data" => Date.current.. )}

  scope :contagem_de_acompanhamentos, -> (profissionais=all) { group(:acompanhamento).count }

  scope :que_nao_realiza_atendimentos, -> { where realiza_atendimentos: [false, nil] }
  scope :que_realiza_atendimentos, -> { where realiza_atendimentos: true }

  scope :ativos, -> { where ativo: true }
  scope :inativos, -> { where ativo: [false, nil] }

  scope :query_like_nome, -> (like) do
    query = "LOWER(nome || ' ' || COALESCE(nome_do_meio, '') || ' '|| sobrenome) LIKE ?", "%#{like.downcase}%"
    if Rails.configuration.database_configuration[Rails.env]["adapter"].downcase == "mysql"
      query = "LOWER(CONCAT(nome, ' ', COALESCE(nome_do_meio, ''), ' ', sobrenome)) LIKE ?", "%#{like.downcase}%"
    end

    joins(:pessoa).where(query)
  end

  scope :no_local_de_atendimento, -> (atendimento_locais) do
    joins(:atendimento_locais).where(atendimento_locais: atendimento_locais)
  end

  scope :no_local_de_atendimento_por_id, -> (atendimento_locais_id) do
    joins(:atendimento_locais).where(atendimento_locais: {id: atendimento_locais_id})
  end

  scope :do_sexo_feminino, -> { joins(:pessoa).where(pessoa: {feminino: true}) }
  scope :mulheres, -> { do_sexo_feminino }
  scope :do_sexo_masculino, -> { joins(:pessoa).where(pessoa: {feminino: [false, nil]}) }
  scope :homens, -> { do_sexo_masculino }

  default_scope { includes(:pessoa, :usuario, :profissional_funcao) }


  alias clientes pacientes
  alias folgas profissional_folgas
  alias horarios_disponiveis profissional_horarios

  def documento
    if profissional_funcao.documento_tipo == nil then return "" end

    "#{profissional_funcao.documento_tipo} #{('00' + documento_regiao_id.to_s)[-2..] }/#{documento_valor}"
  end

  def method_missing(method_name, *args)
    pessoa.respond_to?(method_name) ? pessoa.send(method_name, *args) : nil
  end

  def username_padrao
    n = pessoa.nome_e_sobrenome.split.reverse
    "#{n[0].downcase}.#{n[1].downcase}"
  end

  def funcao
    pessoa.feminino? ? (profissional_funcao.flexao_feminino || profissional_funcao.funcao[..-2] +  'a') : profissional_funcao.funcao
  end

  def servico
    profissional_funcao.servico
  end

  def descricao_profissional
    funcao + ' ' + documento
  end

  def descricao_completa
    nome_completo + ' - ' + funcao + ' ' + documento
  end

  def descricao_abreviada
    "#{funcao[..2]} #{nome_abreviado}"
  end

  def acompanhamentos_em_andamento
    acompanhamentos.where(data_final: nil, acompanhamento_finalizacao_motivo: nil)
  end

  def acompanhamentos_finalizados
    acompanhamentos.where.not(data_final: nil, acompanhamento_finalizacao_motivo: nil)
  end

  def atendimentos_futuros
    #atendimentos.where("DATEDIFF(data, CURRENT_DATE) > 0 OR (DATEDIFF(data, CURRENT_DATE) = 0 AND HOUR(horario) > HOUR(CURRENT_TIME))").order(data: :asc, horario: :asc)
    atendimentos.where(data: Date.current..)
  end

  def financeiro_soma_atendimentos de: Date.current.beginning_of_month, ate: Date.current.end_of_month
    atendimento_valores.joins(:atendimento).where(atendimento: { data: de.to_date..ate.to_date }).sum(:valor)
  end

  def financeiro_soma_atendimentos_todos
    atendimento_valores.sum(:valor)
  end

  def financeiro_soma_liquida_atendimentos_todos
    atendimento_valores.sum("valor - (valor * taxa_porcentagem_externa / 10000) - (valor * taxa_porcentagem_interna / 10000)")
  end

  def financeiro_soma_taxa_clinica de: Date.current.beginning_of_month, ate: Date.current.end_of_month
    atendimento_valores.joins(:atendimento).where(atendimento: {data: de.to_date..ate.to_date}).sum("valor * taxa_porcentagem_interna / 10000")
  end

  def financeiro_soma_taxa_clinica_todos
    atendimento_valores.sum("valor * taxa_porcentagem_interna / 10000")
  end

  def financeiro_soma_taxa_externa de: Date.current.beginning_of_month, ate: Date.current.end_of_month
    atendimento_valores.joins(:atendimento).where(atendimento: {data: de.to_date..ate.to_date}).sum("valor * taxa_porcentagem_externa / 10000")
  end

  def financeiro_soma_taxa_externa_todos
    atendimento_valores.sum("valor * taxa_porcentagem_externa / 10000")
  end

  def financeiro_soma_liquida_atendimentos de: Date.current.beginning_of_month, ate: Date.current.end_of_month
    atendimento_valores.joins(:atendimento).where(atendimento: { data: de.to_date..ate.to_date }).sum("valor - (valor * taxa_porcentagem_externa / 10000) - (valor * taxa_porcentagem_interna / 10000)")
  end

  def financeiro_soma_repasses
    repasses.sum(:valor)
  end

  def financeiro_repasse_faltante
    recebimentos.sum(:valor) - repasses.sum(:valor)
  end

  def financeiro_soma_recebimentos
    recebimentos.sum(:valor)
  end

  def financeiro_clinica_deve
    recebimentos.sum("valor - (valor * taxa_porcentagem_clinica / 10000)") - repasses.sum(:valor)
  end

  def horarios_preenchidos_registrados
    acompanhamento_horarios.de_acompanhamentos_em_andamento.map { |acompanhamento_horario| profissional_horarios.find_by(semana_dia: acompanhamento_horario.semana_dia, horario: acompanhamento_horario.horario) }
  end

  def de_folga?(data = Date.current)
    folgas.em_andamento(data).first
  end

  def default_display
    descricao_completa
  end

  def horarios_disponiveis
    excluir = horarios_preenchidos_registrados
    disponivel = profissional_horarios - excluir
  end

  def agenda(periodo=Date.current.all_week)
    periodo = periodo.class.to_s == "Range" ? periodo : periodo..periodo
    agenda_final = {}
    profissional_horarios.map { |horario|
      periodo.map { |data|
        agenda_final[data] = agenda_final[data] || []
        atendimentos_do_dia = atendimentos.do_periodo(data)
        atendimento_do_horario = atendimentos_do_dia.where(horario: horario.horario, data: data).or(atendimentos_do_dia.where(horario_reagendamento: horario.horario, data_reagendamento: data)).or(atendimentos_do_dia.where(horario_reagendamento: horario.horario, data: data)).or(atendimentos_do_dia.where(horario: horario.horario, data_reagendamento: data)).map do |atendimento|
          atendimento if atendimento.horario_inicio_verdadeiro == horario.horario && atendimento.data_inicio_verdadeira == data
        end.compact
        agenda_final[data] << {
          profissional_horario: horario,
          horario: horario.horario,
          de_folga: profissional_folgas.no_periodo(data).first,
          atendendo: atendimento_do_horario,
          reservado: horario.acompanhamento_horarios.de_acompanhamentos_em_andamento,
          atendimento_local: horario.atendimento_local,
          atendimento_plataforma: horario.atendimento_plataforma,
        } if data.wday == horario.semana_dia_id
      }
    }
    agenda_final
  end

  def chave_pix
    chave_pix_02 || chave_pix_01
  end

  def self.para_csv collection = all
    CSV.generate(col_sep: ",") do |csv|
      csv << [
        "NOME COMPLETO",
        "SEXO",
        "DATA NASCIMENTO",
        "CPF",
        "FONE",
        "EMAIL",
        "NATURAL DE",
        "CEP",
        "ENDEREÇO",
        "PAÍS",
        "FUNÇÃO",
        "DOCUMENTO",
        "ATIVO",
        "DESLIGADO",
        "REALIZA ATENDIMENTOS NA CLÍNICA",
        "CHAVE PIX 01",
        "CHAVE PIX 02",
      ]

      collection.each do |p|
        csv << [
          p.nome_completo,
          p.pessoa.render_sexo,
          p.pessoa.data_nascimento,
          p.render_cpf,
          p.render_fone,
          p.email,
          p.pessoa.nascimento_pais&.nome,
          p.pessoa.endereco_cep,
          p.pessoa.render_endereco,
          p.pessoa.pais&.nome,
          p.funcao,
          p.documento,
          p.ativo,
          p.desligado,
          p.realiza_atendimentos,
          p.chave_pix_01,
          p.chave_pix_02,
        ]
      end
    end
  end
end
