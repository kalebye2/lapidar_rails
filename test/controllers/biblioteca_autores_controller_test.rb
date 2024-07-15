require "test_helper"

class BibliotecaAutoresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @biblioteca_autor = biblioteca_autores(:one)
  end

  test "should get index" do
    get biblioteca_autores_url
    assert_response :success
  end

  test "should get new" do
    get new_biblioteca_autor_url
    assert_response :success
  end

  test "should create biblioteca_autor" do
    assert_difference("BibliotecaAutor.count") do
      post biblioteca_autores_url, params: { biblioteca_autor: { bio: @biblioteca_autor.bio, feminino: @biblioteca_autor.feminino, link: @biblioteca_autor.link, nome: @biblioteca_autor.nome, nome_do_meio: @biblioteca_autor.nome_do_meio, ordem: @biblioteca_autor.ordem, sobrenome: @biblioteca_autor.sobrenome } }
    end

    assert_redirected_to biblioteca_autor_url(BibliotecaAutor.last)
  end

  test "should show biblioteca_autor" do
    get biblioteca_autor_url(@biblioteca_autor)
    assert_response :success
  end

  test "should get edit" do
    get edit_biblioteca_autor_url(@biblioteca_autor)
    assert_response :success
  end

  test "should update biblioteca_autor" do
    patch biblioteca_autor_url(@biblioteca_autor), params: { biblioteca_autor: { bio: @biblioteca_autor.bio, feminino: @biblioteca_autor.feminino, link: @biblioteca_autor.link, nome: @biblioteca_autor.nome, nome_do_meio: @biblioteca_autor.nome_do_meio, ordem: @biblioteca_autor.ordem, sobrenome: @biblioteca_autor.sobrenome } }
    assert_redirected_to biblioteca_autor_url(@biblioteca_autor)
  end

  test "should destroy biblioteca_autor" do
    assert_difference("BibliotecaAutor.count", -1) do
      delete biblioteca_autor_url(@biblioteca_autor)
    end

    assert_redirected_to biblioteca_autores_url
  end
end
