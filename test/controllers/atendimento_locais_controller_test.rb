require "test_helper"

class AtendimentoLocaisControllerTest < ActionDispatch::IntegrationTest
  setup do
    @atendimento_local = atendimento_locais(:one)
  end

  test "should get index" do
    get atendimento_locais_url
    assert_response :success
  end

  test "should get new" do
    get new_atendimento_local_url
    assert_response :success
  end

  test "should create atendimento_local" do
    assert_difference("AtendimentoLocal.count") do
      post atendimento_locais_url, params: { atendimento_local: { atendimento_local_tipo_id: @atendimento_local.atendimento_local_tipo_id, cidade: @atendimento_local.cidade, descricao: @atendimento_local.descricao, endereco_cep: @atendimento_local.endereco_cep, endereco_complemento: @atendimento_local.endereco_complemento, endereco_logradouro: @atendimento_local.endereco_logradouro, endereco_numero: @atendimento_local.endereco_numero, estado: @atendimento_local.estado, latitude: @atendimento_local.latitude, longitude: @atendimento_local.longitude, pais_id: @atendimento_local.pais_id } }
    end

    assert_redirected_to atendimento_local_url(AtendimentoLocal.last)
  end

  test "should show atendimento_local" do
    get atendimento_local_url(@atendimento_local)
    assert_response :success
  end

  test "should get edit" do
    get edit_atendimento_local_url(@atendimento_local)
    assert_response :success
  end

  test "should update atendimento_local" do
    patch atendimento_local_url(@atendimento_local), params: { atendimento_local: { atendimento_local_tipo_id: @atendimento_local.atendimento_local_tipo_id, cidade: @atendimento_local.cidade, descricao: @atendimento_local.descricao, endereco_cep: @atendimento_local.endereco_cep, endereco_complemento: @atendimento_local.endereco_complemento, endereco_logradouro: @atendimento_local.endereco_logradouro, endereco_numero: @atendimento_local.endereco_numero, estado: @atendimento_local.estado, latitude: @atendimento_local.latitude, longitude: @atendimento_local.longitude, pais_id: @atendimento_local.pais_id } }
    assert_redirected_to atendimento_local_url(@atendimento_local)
  end

  test "should destroy atendimento_local" do
    assert_difference("AtendimentoLocal.count", -1) do
      delete atendimento_local_url(@atendimento_local)
    end

    assert_redirected_to atendimento_locais_url
  end
end
