require "test_helper"

class NeuropsicologicoAdultoAnamnesesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @neuropsicologico_adulto_anamnese = neuropsicologico_adulto_anamneses(:one)
  end

  test "should get index" do
    get neuropsicologico_adulto_anamneses_url
    assert_response :success
  end

  test "should get new" do
    get new_neuropsicologico_adulto_anamnese_url
    assert_response :success
  end

  test "should create neuropsicologico_adulto_anamnese" do
    assert_difference("NeuropsicologicoAdultoAnamnese.count") do
      post neuropsicologico_adulto_anamneses_url, params: { neuropsicologico_adulto_anamnese: { alimentacao: @neuropsicologico_adulto_anamnese.alimentacao, antecedentes_familiares: @neuropsicologico_adulto_anamnese.antecedentes_familiares, aspectos_psicoemocionais: @neuropsicologico_adulto_anamnese.aspectos_psicoemocionais, aspectos_psicossociais: @neuropsicologico_adulto_anamnese.aspectos_psicossociais, atendimento_id: @neuropsicologico_adulto_anamnese.atendimento_id, autonomia_atividades: @neuropsicologico_adulto_anamnese.autonomia_atividades, comorbidades: @neuropsicologico_adulto_anamnese.comorbidades, desenvolvimento_neuropsicomotor: @neuropsicologico_adulto_anamnese.desenvolvimento_neuropsicomotor, diagnostico_preliminar: @neuropsicologico_adulto_anamnese.diagnostico_preliminar, escolaridade_anos: @neuropsicologico_adulto_anamnese.escolaridade_anos, habilidades_afetadas: @neuropsicologico_adulto_anamnese.habilidades_afetadas, historico_medico: @neuropsicologico_adulto_anamnese.historico_medico, historico_ocupacional: @neuropsicologico_adulto_anamnese.historico_ocupacional, historico_profissional: @neuropsicologico_adulto_anamnese.historico_profissional, medicacoes_em_uso: @neuropsicologico_adulto_anamnese.medicacoes_em_uso, motivo_encaminhamento: @neuropsicologico_adulto_anamnese.motivo_encaminhamento, plano_tratamento: @neuropsicologico_adulto_anamnese.plano_tratamento, prognostico: @neuropsicologico_adulto_anamnese.prognostico, quem_encaminhou: @neuropsicologico_adulto_anamnese.quem_encaminhou, sono: @neuropsicologico_adulto_anamnese.sono, uso_drogas_ilicitas: @neuropsicologico_adulto_anamnese.uso_drogas_ilicitas } }
    end

    assert_redirected_to neuropsicologico_adulto_anamnese_url(NeuropsicologicoAdultoAnamnese.last)
  end

  test "should show neuropsicologico_adulto_anamnese" do
    get neuropsicologico_adulto_anamnese_url(@neuropsicologico_adulto_anamnese)
    assert_response :success
  end

  test "should get edit" do
    get edit_neuropsicologico_adulto_anamnese_url(@neuropsicologico_adulto_anamnese)
    assert_response :success
  end

  test "should update neuropsicologico_adulto_anamnese" do
    patch neuropsicologico_adulto_anamnese_url(@neuropsicologico_adulto_anamnese), params: { neuropsicologico_adulto_anamnese: { alimentacao: @neuropsicologico_adulto_anamnese.alimentacao, antecedentes_familiares: @neuropsicologico_adulto_anamnese.antecedentes_familiares, aspectos_psicoemocionais: @neuropsicologico_adulto_anamnese.aspectos_psicoemocionais, aspectos_psicossociais: @neuropsicologico_adulto_anamnese.aspectos_psicossociais, atendimento_id: @neuropsicologico_adulto_anamnese.atendimento_id, autonomia_atividades: @neuropsicologico_adulto_anamnese.autonomia_atividades, comorbidades: @neuropsicologico_adulto_anamnese.comorbidades, desenvolvimento_neuropsicomotor: @neuropsicologico_adulto_anamnese.desenvolvimento_neuropsicomotor, diagnostico_preliminar: @neuropsicologico_adulto_anamnese.diagnostico_preliminar, escolaridade_anos: @neuropsicologico_adulto_anamnese.escolaridade_anos, habilidades_afetadas: @neuropsicologico_adulto_anamnese.habilidades_afetadas, historico_medico: @neuropsicologico_adulto_anamnese.historico_medico, historico_ocupacional: @neuropsicologico_adulto_anamnese.historico_ocupacional, historico_profissional: @neuropsicologico_adulto_anamnese.historico_profissional, medicacoes_em_uso: @neuropsicologico_adulto_anamnese.medicacoes_em_uso, motivo_encaminhamento: @neuropsicologico_adulto_anamnese.motivo_encaminhamento, plano_tratamento: @neuropsicologico_adulto_anamnese.plano_tratamento, prognostico: @neuropsicologico_adulto_anamnese.prognostico, quem_encaminhou: @neuropsicologico_adulto_anamnese.quem_encaminhou, sono: @neuropsicologico_adulto_anamnese.sono, uso_drogas_ilicitas: @neuropsicologico_adulto_anamnese.uso_drogas_ilicitas } }
    assert_redirected_to neuropsicologico_adulto_anamnese_url(@neuropsicologico_adulto_anamnese)
  end

  test "should destroy neuropsicologico_adulto_anamnese" do
    assert_difference("NeuropsicologicoAdultoAnamnese.count", -1) do
      delete neuropsicologico_adulto_anamnese_url(@neuropsicologico_adulto_anamnese)
    end

    assert_redirected_to neuropsicologico_adulto_anamneses_url
  end
end
