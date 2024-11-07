require "application_system_test_case"

class BibliotecaObrasTest < ApplicationSystemTestCase
  setup do
    @biblioteca_obra = biblioteca_obras(:one)
  end

  test "visiting the index" do
    visit biblioteca_obras_url
    assert_selector "h1", text: "Biblioteca obras"
  end

  test "should create biblioteca obra" do
    visit biblioteca_obras_url
    click_on "New biblioteca obra"

    fill_in "Biblioteca editora id", with: @biblioteca_obra.biblioteca_editora_id_id
    fill_in "Biblioteca obra tipo", with: @biblioteca_obra.biblioteca_obra_tipo_id
    fill_in "Biblioteca periodico", with: @biblioteca_obra.biblioteca_periodico_id
    fill_in "Caminho", with: @biblioteca_obra.caminho
    fill_in "Data publicacao", with: @biblioteca_obra.data_publicacao
    fill_in "Edicao", with: @biblioteca_obra.edicao
    fill_in "Isbn", with: @biblioteca_obra.isbn
    fill_in "Num paginas", with: @biblioteca_obra.num_paginas
    check "Obra virtual" if @biblioteca_obra.obra_virtual
    fill_in "Ordem", with: @biblioteca_obra.ordem
    fill_in "Resumo", with: @biblioteca_obra.resumo
    fill_in "Subtitulo", with: @biblioteca_obra.subtitulo
    fill_in "Titulo", with: @biblioteca_obra.titulo
    fill_in "Volume", with: @biblioteca_obra.volume
    click_on "Create Biblioteca obra"

    assert_text "Biblioteca obra was successfully created"
    click_on "Back"
  end

  test "should update Biblioteca obra" do
    visit biblioteca_obra_url(@biblioteca_obra)
    click_on "Edit this biblioteca obra", match: :first

    fill_in "Biblioteca editora id", with: @biblioteca_obra.biblioteca_editora_id_id
    fill_in "Biblioteca obra tipo", with: @biblioteca_obra.biblioteca_obra_tipo_id
    fill_in "Biblioteca periodico", with: @biblioteca_obra.biblioteca_periodico_id
    fill_in "Caminho", with: @biblioteca_obra.caminho
    fill_in "Data publicacao", with: @biblioteca_obra.data_publicacao
    fill_in "Edicao", with: @biblioteca_obra.edicao
    fill_in "Isbn", with: @biblioteca_obra.isbn
    fill_in "Num paginas", with: @biblioteca_obra.num_paginas
    check "Obra virtual" if @biblioteca_obra.obra_virtual
    fill_in "Ordem", with: @biblioteca_obra.ordem
    fill_in "Resumo", with: @biblioteca_obra.resumo
    fill_in "Subtitulo", with: @biblioteca_obra.subtitulo
    fill_in "Titulo", with: @biblioteca_obra.titulo
    fill_in "Volume", with: @biblioteca_obra.volume
    click_on "Update Biblioteca obra"

    assert_text "Biblioteca obra was successfully updated"
    click_on "Back"
  end

  test "should destroy Biblioteca obra" do
    visit biblioteca_obra_url(@biblioteca_obra)
    click_on "Destroy this biblioteca obra", match: :first

    assert_text "Biblioteca obra was successfully destroyed"
  end
end
