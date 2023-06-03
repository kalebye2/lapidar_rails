class ApplicationController < ActionController::Base

  def init
  end

  def index
=begin
    ActiveRecord::Base.establish_connection(:production)
    if ActiveRecord::Base.connection.data_sources.empty?
      redirect_to({ action: :init })
      return
    end
=end
    #@c_psicologos = Psicologo.count
    #@c_usuarios = Usuario.count
    #@c_profissionals = Profissional.count
    #@atendimentos = Atendimento.where(data: Time.now.beginning_of_month.beginning_of_week..Time.now.end_of_month.end_of_week).order(data: :asc, horario: :asc)
    #@atendimentos_hoje = @atendimentos.where(data: Date.today)

    
    @start_date = params[:start_date] || Date.today.beginning_of_week.strftime("%Y-W%U")

    @atendimentos = Atendimento.where(data: @start_date.to_date.beginning_of_week..@start_date.to_date.end_of_week).order(data: :asc, horario: :asc)
    @atendimentos_hoje = Atendimento.where(data: Date.today).order(horario: :asc)
  end


  def pdf_download
    pdf = Prawn::Document.new
    pdf.text "Hello World!"
    send_data(pdf.render,
              filename: "hello.pdf",
             type: "application/pdf")
  end


  def pdf_preview
    pdf = Prawn::Document.new
    pdf.text "This is a preview"

    pdf.start_new_page
    pdf.text "New Page"
    1000.times do |i|
      pdf.text "Line #{i}"
    end
    send_data(pdf.render,
              filename: "preview.pdf",
             type: "application/pdf",
             disposition: "inline")

  end


  def execute_statement(sql)
    results = ActiveRecord::Base.connection.execute(sql)

    if results.present?
      return results
    else
      return nil
    end
  end


  def abreviar
    string.split.map { |n| n[0] == n[0].downcase ? '' : n[0] }.join(". ") + '.'
  end

end
