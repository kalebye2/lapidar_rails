require "application_system_test_case"

class NeuropsicologicoAdultoAnamnesesTest < ApplicationSystemTestCase
  setup do
    @neuropsicologico_adulto_anamnese = neuropsicologico_adulto_anamneses(:one)
  end

  test "visiting the index" do
    visit neuropsicologico_adulto_anamneses_url
    assert_selector "h1", text: "Neuropsicologico adulto anamneses"
  end

  test "should create neuropsicologico adulto anamnese" do
    visit neuropsicologico_adulto_anamneses_url
    click_on "New neuropsicologico adulto anamnese"

    fill_in "Alimentacao", with: @neuropsicologico_adulto_anamnese.alimentacao
    fill_in "Antecedentes familiares", with: @neuropsicologico_adulto_anamnese.antecedentes_familiares
    fill_in "Aspectos psicoemocionais", with: @neuropsicologico_adulto_anamnese.aspectos_psicoemocionais
    fill_in "Aspectos psicossociais", with: @neuropsicologico_adulto_anamnese.aspectos_psicossociais
    fill_in "Atendimento", with: @neuropsicologico_adulto_anamnese.atendimento_id
    fill_in "Autonomia atividades", with: @neuropsicologico_adulto_anamnese.autonomia_atividades
    fill_in "Comorbidades", with: @neuropsicologico_adulto_anamnese.comorbidades
    fill_in "Desenvolvimento neuropsicomotor", with: @neuropsicologico_adulto_anamnese.desenvolvimento_neuropsicomotor
    fill_in "Diagnostico preliminar", with: @neuropsicologico_adulto_anamnese.diagnostico_preliminar
    fill_in "Escolaridade anos", with: @neuropsicologico_adulto_anamnese.escolaridade_anos
    fill_in "Habilidades afetadas", with: @neuropsicologico_adulto_anamnese.habilidades_afetadas
    fill_in "Historico medico", with: @neuropsicologico_adulto_anamnese.historico_medico
    fill_in "Historico ocupacional", with: @neuropsicologico_adulto_anamnese.historico_ocupacional
    fill_in "Historico profissional", with: @neuropsicologico_adulto_anamnese.historico_profissional
    fill_in "Medicacoes em uso", with: @neuropsicologico_adulto_anamnese.medicacoes_em_uso
    fill_in "Motivo encaminhamento", with: @neuropsicologico_adulto_anamnese.motivo_encaminhamento
    fill_in "Plano tratamento", with: @neuropsicologico_adulto_anamnese.plano_tratamento
    fill_in "Prognostico", with: @neuropsicologico_adulto_anamnese.prognostico
    fill_in "Quem encaminhou", with: @neuropsicologico_adulto_anamnese.quem_encaminhou
    fill_in "Sono", with: @neuropsicologico_adulto_anamnese.sono
    fill_in "Uso drogas ilicitas", with: @neuropsicologico_adulto_anamnese.uso_drogas_ilicitas
    click_on "Create Neuropsicologico adulto anamnese"

    assert_text "Neuropsicologico adulto anamnese was successfully created"
    click_on "Back"
  end

  test "should update Neuropsicologico adulto anamnese" do
    visit neuropsicologico_adulto_anamnese_url(@neuropsicologico_adulto_anamnese)
    click_on "Edit this neuropsicologico adulto anamnese", match: :first

    fill_in "Alimentacao", with: @neuropsicologico_adulto_anamnese.alimentacao
    fill_in "Antecedentes familiares", with: @neuropsicologico_adulto_anamnese.antecedentes_familiares
    fill_in "Aspectos psicoemocionais", with: @neuropsicologico_adulto_anamnese.aspectos_psicoemocionais
    fill_in "Aspectos psicossociais", with: @neuropsicologico_adulto_anamnese.aspectos_psicossociais
    fill_in "Atendimento", with: @neuropsicologico_adulto_anamnese.atendimento_id
    fill_in "Autonomia atividades", with: @neuropsicologico_adulto_anamnese.autonomia_atividades
    fill_in "Comorbidades", with: @neuropsicologico_adulto_anamnese.comorbidades
    fill_in "Desenvolvimento neuropsicomotor", with: @neuropsicologico_adulto_anamnese.desenvolvimento_neuropsicomotor
    fill_in "Diagnostico preliminar", with: @neuropsicologico_adulto_anamnese.diagnostico_preliminar
    fill_in "Escolaridade anos", with: @neuropsicologico_adulto_anamnese.escolaridade_anos
    fill_in "Habilidades afetadas", with: @neuropsicologico_adulto_anamnese.habilidades_afetadas
    fill_in "Historico medico", with: @neuropsicologico_adulto_anamnese.historico_medico
    fill_in "Historico ocupacional", with: @neuropsicologico_adulto_anamnese.historico_ocupacional
    fill_in "Historico profissional", with: @neuropsicologico_adulto_anamnese.historico_profissional
    fill_in "Medicacoes em uso", with: @neuropsicologico_adulto_anamnese.medicacoes_em_uso
    fill_in "Motivo encaminhamento", with: @neuropsicologico_adulto_anamnese.motivo_encaminhamento
    fill_in "Plano tratamento", with: @neuropsicologico_adulto_anamnese.plano_tratamento
    fill_in "Prognostico", with: @neuropsicologico_adulto_anamnese.prognostico
    fill_in "Quem encaminhou", with: @neuropsicologico_adulto_anamnese.quem_encaminhou
    fill_in "Sono", with: @neuropsicologico_adulto_anamnese.sono
    fill_in "Uso drogas ilicitas", with: @neuropsicologico_adulto_anamnese.uso_drogas_ilicitas
    click_on "Update Neuropsicologico adulto anamnese"

    assert_text "Neuropsicologico adulto anamnese was successfully updated"
    click_on "Back"
  end

  test "should destroy Neuropsicologico adulto anamnese" do
    visit neuropsicologico_adulto_anamnese_url(@neuropsicologico_adulto_anamnese)
    click_on "Destroy this neuropsicologico adulto anamnese", match: :first

    assert_text "Neuropsicologico adulto anamnese was successfully destroyed"
  end
end
