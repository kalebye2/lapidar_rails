class RelatosController < ApplicationController
  before_action :set_relato, only: %i[ show show_pdf edit update destroy ]

  def index
    @relatos = Relato.all.order(id: :desc)
  end

  def show
  end

  def show_pdf
        hoje = Time.now.strftime("%Y-%m-%d")
        hoje_formatado = Time.now.strftime("%d/%m/%Y")
        data_relato_doc = @relato.atendimento.data.strftime("%Y-%m-%d")
        data_relato = @relato.atendimento.data.strftime("%d/%m/%Y")
        hora_relato = @relato.atendimento.horario.strftime("%H%M")
        hora_relato_formatado = @relato.atendimento.horario.strftime("%Hh%M")
        nome_documento = "#{@relato.atendimento.pessoa.nome_completo}_relato_#{data_relato_doc}-#{hora_relato}"

        pdf = Prawn::Document.new
        pdf.text "#{@relato.atendimento.acompanhamento.pessoa.nome_completo} - Relato"
        pdf.text "Atendimento do dia #{data_relato} às #{hora_relato_formatado}"
        pdf.text "Documento gerado em " + (hoje_formatado) + " às " + (Time.now.strftime("%Hh%M"))

        pdf.stroke_horizontal_rule
        pdf.move_down 20
        # atendimentos
        pdf.text @relato.relato

        send_data(pdf.render,
                  filename: "#{nome_documento}.pdf",
                  type: "application/pdf",
                  disposition: "inline"
                 )
  end

  def new
    @relato = Relato.new
  end

  def edit
  end

  def create
    @relato = Relato.new(relato_params)
    respond_to do |format|
      if @relato.save
        format.html { redirect_to relato_url(@relato), notice: "Relato registrado." }
        format.json { render :show, status: :created, location: @relato }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @relato.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @relato.update(relato_params)
        format.html { redirect_to relato_url(@relato), notice: "relato was successfully updated. #{@relato.atendimento.consideracoes} #{relato_params}" }
        format.json { render :show, status: :ok, location: @relato }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @relato.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  end


  private

  def set_relato
    @relato = Relato.find(params[:id])
  end

  def relato_params
    params.require(:relato).permit(:id, :relato)
  end

end
