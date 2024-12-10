module RecebimentosHelper
  def links_download descricao = "Baixar relatório", parameters: {}
    parameters = parameters.to_h
    text = <<TEXT
    <li>
    #{link_to descricao, "javascript:void(0);", class: "icon-download3"}
        <ul>
          <li>
          #{link_download parameters: parameters, format: :csv, format_name: "CSV", icon: "table2"}
          </li>
          <li>
          #{link_download parameters: parameters, format: :xlsx, format_name: "Excel", icon: "file-excel"}
          </li>
          <li>
          #{link_download parameters: parameters, format: :pdf, format_name: "PDF", icon: "file-pdf", target: :blank}
          </li>
          <li>
          #{link_download parameters: parameters.merge(filetype: :pdf), format: :zip, format_name: "Recibos (PDF)", icon: "file-zip"}
          #{link_download parameters: parameters, format: :zip, format_name: "Recibos (Markdown)", icon: "file-zip"}
          </li>
        </ul>
      </li>
TEXT
    text.html_safe
  end

  def link_download format: :csv, format_name: nil, icon: "file-empty", parameters: {}, target: nil
    parameters = parameters.to_h
    link_to format_name || format&.to_s&.humanize, recebimentos_path(parameters.merge(format: format || :csv)), class: "icon-#{icon}", target: target
  end
end
