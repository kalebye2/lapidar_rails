require 'test_helper'

class PaisesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pais = paises(:one)
  end

  test "should get index" do
    get paises_url
    assert_response :success
  end

  test "should get new" do
    get new_pais_url
    assert_response :success
  end

  test "should create pais" do
    assert_difference('Pais.count') do
      post paises_url, params: { pais: { continente_id: @pais.continente_id, iso_3166_numerico: @pais.iso_3166_numerico, nome: @pais.nome, nome_ingles: @pais.nome_ingles, nome_oficial: @pais.nome_oficial, sigla_2: @pais.sigla_2, sigla_3: @pais.sigla_3 } }
    end

    assert_redirected_to pais_url(Pais.last)
  end

  test "should show pais" do
    get pais_url(@pais)
    assert_response :success
  end

  test "should get edit" do
    get edit_pais_url(@pais)
    assert_response :success
  end

  test "should update pais" do
    patch pais_url(@pais), params: { pais: { continente_id: @pais.continente_id, iso_3166_numerico: @pais.iso_3166_numerico, nome: @pais.nome, nome_ingles: @pais.nome_ingles, nome_oficial: @pais.nome_oficial, sigla_2: @pais.sigla_2, sigla_3: @pais.sigla_3 } }
    assert_redirected_to pais_url(@pais)
  end

  test "should destroy pais" do
    assert_difference('Pais.count', -1) do
      delete pais_url(@pais)
    end

    assert_redirected_to paises_url
  end
end
