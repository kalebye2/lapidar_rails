class DocumentosController < ApplicationController
  def index
  end

  def gerar
    @titulo = params[:title].presence || "Documento sem título"
    @data_atual = params[:data_atual]
    @assinatura_profissional = params[:assinatura_profissional]
    @conteudo = params[:content].presence || "Documento sem conteúdo."
    @papersize = params[:papersize] || :a4
    @fontsize = params[:fontsize] || 8
    @parskip = params[:parskip] || 1.5
    @parskip_unit = params[:parskip_unit] || :em
    @parskip_trigger = params[:parskip_trigger]
    @parindent = params[:parindent] || 2
    @parindent_unit = params[:parindent_unit] || :em
    @parindent_trigger = params[:parindent_trigger]
    @baselinestretch = params[:baselinestretch] || 1.5
    @baselinestretch_trigger = params[:baselinestretch_trigger]
    @pageshow = params[:pageshow]
    @lastpage = params[:lastpage]
    @footer = params[:footer]
    @header = params[:header]

    respond_to do |format|
      format.html
      format.md do
        hoje = Time.now.strftime("%Y-%m-%d")
        hoje_formatado = Time.now.strftime("%d/%m/%Y")
        nome_documento = "#{@titulo}_#{hoje}_#{usuario_atual.profissional.nome_completo.parameterize}"
        response.headers['Content-Type'] = 'text/markdown'
        response.headers['Content-Disposition'] = "attachment; filename=#{nome_documento}.md"
      end
    end
  end
end
