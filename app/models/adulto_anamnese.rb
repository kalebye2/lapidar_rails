class AdultoAnamnese < ApplicationRecord
  include ApplicationHelper
  belongs_to :pessoa
  belongs_to :profissional
  belongs_to :acompanhamento_tipo, optional: true
  belongs_to :pessoa_responsavel, class_name: "Pessoa", optional: true

  scope :do_periodo, -> (periodo=Date.current.all_month) { where data: periodo }
  scope :do_profissional_com_id, -> (id) { joins(:profissional).where(profissional: Profissional.find(id)) }

  def dados
    {
      identificação: {
        nome_completo: pessoa.nome_completo,
        data_de_nascimento: render_data_brasil(pessoa.data_nascimento),
        idade: pessoa.render_idade(data),
        sexo: pessoa.render_sexo,
        serviço_procurado: acompanhamento_tipo&.tipo&.upcase,
        profissional: profissional&.descricao_completa,
        data_da_consulta: data&.strftime("%d/%m/%Y"),
        motivo_da_consulta: motivo_consulta,
        encaminhado_por: quem_encaminhou,
      },
      histórico: {
        anos_de_escolaridade: escolaridade_anos,
        profissional: historico_profissional,
        ocupacional: historico_ocupacional,
        médico: historico_medico,
        antecedentes_familiares: antecedentes_familiares,
        desenvolvimento_neuropsicomotor: desenvolvimento_neuropsicomotor,
      },
      condição_atual: {
        aspectos_psicoemocionais: aspectos_psicoemocionais,
        aspectos_psicossociais: aspectos_psicossociais,
        comorbidades: comorbidades,
        alimentação: alimentacao,
        sono: sono,
        medicações_em_uso: medicacoes_em_uso,
        faz_uso_de_drogas_ilícitas: uso_drogas_ilicitas,
        "tem autonomia nas atividades?" => autonomia_atividades,
        habilidades_afetadas: habilidades_afetadas,
      },
      anotações_do_profissional: {
        diagnóstico_preliminar: diagnostico_preliminar || "Não definido",
        plano_de_ação: plano_tratamento,
        prognóstico: prognostico,
      }.compact
    }
  end
end
