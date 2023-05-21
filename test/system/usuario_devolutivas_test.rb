require "application_system_test_case"

class UsuarioDevolutivasTest < ApplicationSystemTestCase
  setup do
    @usuario_devolutiva = usuario_devolutivas(:one)
  end

  test "visiting the index" do
    visit usuario_devolutivas_url
    assert_selector "h1", text: "Usuario Devolutivas"
  end

  test "creating a Usuario devolutiva" do
    visit usuario_devolutivas_url
    click_on "New Usuario Devolutiva"

    fill_in "Data", with: @usuario_devolutiva.data
    fill_in "Feedback responsavel", with: @usuario_devolutiva.feedback_responsavel
    fill_in "Orientacoes profissional", with: @usuario_devolutiva.orientacoes_profissional
    fill_in "Profissional", with: @usuario_devolutiva.profissional_id
    fill_in "Usuario", with: @usuario_devolutiva.usuario_id
    fill_in "Usuario responsavel", with: @usuario_devolutiva.usuario_responsavel_id
    click_on "Create Usuario devolutiva"

    assert_text "Usuario devolutiva was successfully created"
    click_on "Back"
  end

  test "updating a Usuario devolutiva" do
    visit usuario_devolutivas_url
    click_on "Edit", match: :first

    fill_in "Data", with: @usuario_devolutiva.data
    fill_in "Feedback responsavel", with: @usuario_devolutiva.feedback_responsavel
    fill_in "Orientacoes profissional", with: @usuario_devolutiva.orientacoes_profissional
    fill_in "Profissional", with: @usuario_devolutiva.profissional_id
    fill_in "Usuario", with: @usuario_devolutiva.usuario_id
    fill_in "Usuario responsavel", with: @usuario_devolutiva.usuario_responsavel_id
    click_on "Update Usuario devolutiva"

    assert_text "Usuario devolutiva was successfully updated"
    click_on "Back"
  end

  test "destroying a Usuario devolutiva" do
    visit usuario_devolutivas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Usuario devolutiva was successfully destroyed"
  end
end
