module MarkdownHelper
  # markdown
  def markdown_substituir_paragrafo(texto="", substitui_por="")
    texto.to_s.gsub(/\n\n/, substitui_por)
  end

  # SimpleMDE
  def simplemde_gerar id=""
    "<script>
        var simplemde = simplemde || {};
        simplemde[\"#{id}\"] = new SimpleMDE({ element: document.getElementById(\"#{id}\") });
        simplemde[\"#{id}\"].codemirror.on(\"change\", function() {
                      document.getElementById(\"#{id}\").innerHTML = simplemde[\"#{id}\"].value();
                    });
      </script>".html_safe
  end

  def markdown_to_html valor, default = "Sem informação"
    valor.nil? ? default : Kramdown::Document.new(valor.to_s).to_html.html_safe
  end

  def markdown valor, default = "Sem informação"
    valor.nil? ? default : Kramdown::Document.new(valor.to_s).to_kramdown
  end
end
