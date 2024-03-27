require "test_helper"

class ProfissionalHorariosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @profissional_horario = profissional_horarios(:one)
  end

  test "should get index" do
    get profissional_horarios_url
    assert_response :success
  end

  test "should get new" do
    get new_profissional_horario_url
    assert_response :success
  end

  test "should create profissional_horario" do
    assert_difference("ProfissionalHorario.count") do
      post profissional_horarios_url, params: { profissional_horario: { horario: @profissional_horario.horario, profissional_id: @profissional_horario.profissional_id, semana_dia_id: @profissional_horario.semana_dia_id } }
    end

    assert_redirected_to profissional_horario_url(ProfissionalHorario.last)
  end

  test "should show profissional_horario" do
    get profissional_horario_url(@profissional_horario)
    assert_response :success
  end

  test "should get edit" do
    get edit_profissional_horario_url(@profissional_horario)
    assert_response :success
  end

  test "should update profissional_horario" do
    patch profissional_horario_url(@profissional_horario), params: { profissional_horario: { horario: @profissional_horario.horario, profissional_id: @profissional_horario.profissional_id, semana_dia_id: @profissional_horario.semana_dia_id } }
    assert_redirected_to profissional_horario_url(@profissional_horario)
  end

  test "should destroy profissional_horario" do
    assert_difference("ProfissionalHorario.count", -1) do
      delete profissional_horario_url(@profissional_horario)
    end

    assert_redirected_to profissional_horarios_url
  end
end
