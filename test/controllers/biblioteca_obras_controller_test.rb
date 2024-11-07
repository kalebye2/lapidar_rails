require "test_helper"

class BibliotecaObrasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @biblioteca_obra = biblioteca_obras(:one)
  end

  test "should get index" do
    get biblioteca_obras_url
    assert_response :success
  end

  test "should get new" do
    get new_biblioteca_obra_url
    assert_response :success
  end

  test "should create biblioteca_obra" do
    assert_difference("BibliotecaObra.count") do
      post biblioteca_obras_url, params: { biblioteca_obra: { biblioteca_editora_id_id: @biblioteca_obra.biblioteca_editora_id_id, biblioteca_obra_tipo_id: @biblioteca_obra.biblioteca_obra_tipo_id, biblioteca_periodico_id: @biblioteca_obra.biblioteca_periodico_id, caminho: @biblioteca_obra.caminho, data_publicacao: @biblioteca_obra.data_publicacao, edicao: @biblioteca_obra.edicao, isbn: @biblioteca_obra.isbn, num_paginas: @biblioteca_obra.num_paginas, obra_virtual: @biblioteca_obra.obra_virtual, ordem: @biblioteca_obra.ordem, resumo: @biblioteca_obra.resumo, subtitulo: @biblioteca_obra.subtitulo, titulo: @biblioteca_obra.titulo, volume: @biblioteca_obra.volume } }
    end

    assert_redirected_to biblioteca_obra_url(BibliotecaObra.last)
  end

  test "should show biblioteca_obra" do
    get biblioteca_obra_url(@biblioteca_obra)
    assert_response :success
  end

  test "should get edit" do
    get edit_biblioteca_obra_url(@biblioteca_obra)
    assert_response :success
  end

  test "should update biblioteca_obra" do
    patch biblioteca_obra_url(@biblioteca_obra), params: { biblioteca_obra: { biblioteca_editora_id_id: @biblioteca_obra.biblioteca_editora_id_id, biblioteca_obra_tipo_id: @biblioteca_obra.biblioteca_obra_tipo_id, biblioteca_periodico_id: @biblioteca_obra.biblioteca_periodico_id, caminho: @biblioteca_obra.caminho, data_publicacao: @biblioteca_obra.data_publicacao, edicao: @biblioteca_obra.edicao, isbn: @biblioteca_obra.isbn, num_paginas: @biblioteca_obra.num_paginas, obra_virtual: @biblioteca_obra.obra_virtual, ordem: @biblioteca_obra.ordem, resumo: @biblioteca_obra.resumo, subtitulo: @biblioteca_obra.subtitulo, titulo: @biblioteca_obra.titulo, volume: @biblioteca_obra.volume } }
    assert_redirected_to biblioteca_obra_url(@biblioteca_obra)
  end

  test "should destroy biblioteca_obra" do
    assert_difference("BibliotecaObra.count", -1) do
      delete biblioteca_obra_url(@biblioteca_obra)
    end

    assert_redirected_to biblioteca_obras_url
  end
end
