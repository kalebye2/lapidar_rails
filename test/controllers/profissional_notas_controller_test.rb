require 'test_helper'

class ProfissionalNotasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @profissional_nota = profissional_notas(:one)
  end

  test "should get index" do
    get profissional_notas_url
    assert_response :success
  end

  test "should get new" do
    get new_profissional_nota_url
    assert_response :success
  end

  test "should create profissional_nota" do
    assert_difference('ProfissionalNota.count') do
      post profissional_notas_url, params: { profissional_nota: { data: @profissional_nota.data, data_lembrar: @profissional_nota.data_lembrar, hora: @profissional_nota.hora, hora_lembrar: @profissional_nota.hora_lembrar, nota: @profissional_nota.nota, profissional_id: @profissional_nota.profissional_id } }
    end

    assert_redirected_to profissional_nota_url(ProfissionalNota.last)
  end

  test "should show profissional_nota" do
    get profissional_nota_url(@profissional_nota)
    assert_response :success
  end

  test "should get edit" do
    get edit_profissional_nota_url(@profissional_nota)
    assert_response :success
  end

  test "should update profissional_nota" do
    patch profissional_nota_url(@profissional_nota), params: { profissional_nota: { data: @profissional_nota.data, data_lembrar: @profissional_nota.data_lembrar, hora: @profissional_nota.hora, hora_lembrar: @profissional_nota.hora_lembrar, nota: @profissional_nota.nota, profissional_id: @profissional_nota.profissional_id } }
    assert_redirected_to profissional_nota_url(@profissional_nota)
  end

  test "should destroy profissional_nota" do
    assert_difference('ProfissionalNota.count', -1) do
      delete profissional_nota_url(@profissional_nota)
    end

    assert_redirected_to profissional_notas_url
  end
end
