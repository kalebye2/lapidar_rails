require "application_system_test_case"

class BibliotecaAutoresTest < ApplicationSystemTestCase
  setup do
    @biblioteca_autor = biblioteca_autores(:one)
  end

  test "visiting the index" do
    visit biblioteca_autores_url
    assert_selector "h1", text: "Biblioteca autores"
  end

  test "should create biblioteca autor" do
    visit biblioteca_autores_url
    click_on "New biblioteca autor"

    fill_in "Bio", with: @biblioteca_autor.bio
    check "Feminino" if @biblioteca_autor.feminino
    fill_in "Link", with: @biblioteca_autor.link
    fill_in "Nome", with: @biblioteca_autor.nome
    fill_in "Nome do meio", with: @biblioteca_autor.nome_do_meio
    fill_in "Ordem", with: @biblioteca_autor.ordem
    fill_in "Sobrenome", with: @biblioteca_autor.sobrenome
    click_on "Create Biblioteca autor"

    assert_text "Biblioteca autor was successfully created"
    click_on "Back"
  end

  test "should update Biblioteca autor" do
    visit biblioteca_autor_url(@biblioteca_autor)
    click_on "Edit this biblioteca autor", match: :first

    fill_in "Bio", with: @biblioteca_autor.bio
    check "Feminino" if @biblioteca_autor.feminino
    fill_in "Link", with: @biblioteca_autor.link
    fill_in "Nome", with: @biblioteca_autor.nome
    fill_in "Nome do meio", with: @biblioteca_autor.nome_do_meio
    fill_in "Ordem", with: @biblioteca_autor.ordem
    fill_in "Sobrenome", with: @biblioteca_autor.sobrenome
    click_on "Update Biblioteca autor"

    assert_text "Biblioteca autor was successfully updated"
    click_on "Back"
  end

  test "should destroy Biblioteca autor" do
    visit biblioteca_autor_url(@biblioteca_autor)
    click_on "Destroy this biblioteca autor", match: :first

    assert_text "Biblioteca autor was successfully destroyed"
  end
end
