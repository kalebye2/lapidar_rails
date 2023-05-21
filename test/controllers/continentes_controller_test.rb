require 'test_helper'

class ContinentesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @continente = continentes(:one)
  end

  test "should get index" do
    get continentes_url
    assert_response :success
  end

  test "should get new" do
    get new_continente_url
    assert_response :success
  end

  test "should create continente" do
    assert_difference('Continente.count') do
      post continentes_url, params: { continente: { nome: @continente.nome } }
    end

    assert_redirected_to continente_url(Continente.last)
  end

  test "should show continente" do
    get continente_url(@continente)
    assert_response :success
  end

  test "should get edit" do
    get edit_continente_url(@continente)
    assert_response :success
  end

  test "should update continente" do
    patch continente_url(@continente), params: { continente: { nome: @continente.nome } }
    assert_redirected_to continente_url(@continente)
  end

  test "should destroy continente" do
    assert_difference('Continente.count', -1) do
      delete continente_url(@continente)
    end

    assert_redirected_to continentes_url
  end
end
