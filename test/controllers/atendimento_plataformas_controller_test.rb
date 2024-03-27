require "test_helper"

class AtendimentoPlataformasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @atendimento_plataforma = atendimento_plataformas(:one)
  end

  test "should get index" do
    get atendimento_plataformas_url
    assert_response :success
  end

  test "should get new" do
    get new_atendimento_plataforma_url
    assert_response :success
  end

  test "should create atendimento_plataforma" do
    assert_difference("AtendimentoPlataforma.count") do
      post atendimento_plataformas_url, params: { atendimento_plataforma: { descricao: @atendimento_plataforma.descricao, nome: @atendimento_plataforma.nome, site: @atendimento_plataforma.site, taxa_atendimento: @atendimento_plataforma.taxa_atendimento, taxa_fixa: @atendimento_plataforma.taxa_fixa } }
    end

    assert_redirected_to atendimento_plataforma_url(AtendimentoPlataforma.last)
  end

  test "should show atendimento_plataforma" do
    get atendimento_plataforma_url(@atendimento_plataforma)
    assert_response :success
  end

  test "should get edit" do
    get edit_atendimento_plataforma_url(@atendimento_plataforma)
    assert_response :success
  end

  test "should update atendimento_plataforma" do
    patch atendimento_plataforma_url(@atendimento_plataforma), params: { atendimento_plataforma: { descricao: @atendimento_plataforma.descricao, nome: @atendimento_plataforma.nome, site: @atendimento_plataforma.site, taxa_atendimento: @atendimento_plataforma.taxa_atendimento, taxa_fixa: @atendimento_plataforma.taxa_fixa } }
    assert_redirected_to atendimento_plataforma_url(@atendimento_plataforma)
  end

  test "should destroy atendimento_plataforma" do
    assert_difference("AtendimentoPlataforma.count", -1) do
      delete atendimento_plataforma_url(@atendimento_plataforma)
    end

    assert_redirected_to atendimento_plataformas_url
  end
end
