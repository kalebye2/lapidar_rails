class AcompanhamentosController < ApplicationController
  before_action :set_acompanhamento, only: %i[ show edit update destroy caso_detalhes ]

  def index
    @acompanhamentos = Acompanhamento.all.order(data_inicio: :desc)
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @acompanhamento = Acompanhamento.new
  end

  def update
    respond_to do |format|
      if @acompanhamento.update(acompanhamento_params)
        format.html { redirect_to acompanhamento_url(@acompanhamento), notice: "acompanhamento was successfully updated." }
        format.json { render :show, status: :ok, location: @acompanhamento }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @acompanhamento.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  end


  def caso_detalhes
    respond_to do |format|
      format.html

      format.pdf do
        hoje = Time.now.strftime("%Y-%m-%d")
        hoje_formatado = Time.now.strftime("%d/%m/%Y")
        nome_documento = "#{@acompanhamento.usuario.nome_completo}_caso-detalhes_#{hoje}"

        pdf = Prawn::Document.new
        pdf.text "#{@acompanhamento.usuario.nome_completo} - Detalhes do caso"
        pdf.text "Documento gerado em " + (hoje_formatado)

        pdf.stroke_horizontal_rule
        pdf.move_down 20
        # atendimentos
        @acompanhamento.atendimento.each do |at|
          pdf.text (dados_atendimento_pdf at)
          pdf.stroke_horizontal_rule
          pdf.move_down 10
        end

        send_data(pdf.render,
                  filename: "#{nome_documento}.pdf",
                  type: "application/pdf",
                  disposition: "inline"
                 )
      end

    end
  end


  private

  def set_acompanhamento
    @acompanhamento = Acompanhamento.find(params[:id])
  end

  def acompanhamento_params
    params.require(:acompanhamento).permit(:usuario_id, :profissional_id, :plataforma_id, :motivo, :data_inicio, :data_final, :finalizacao_motivo_id, :valor_contrato, :sessoes_contrato, :valor_atual, :sessoes_atuais, :acompanhamento_tipo_id, :menor_de_idade, :usuario_responsavel_id, :sessoes_previstas)
  end

  def dados_atendimento_pdf at
    return "#{at.data.strftime('%d/%m/%Y')}\n#{(at.consideracoes || 'Sem considerações')}"
  end

end
