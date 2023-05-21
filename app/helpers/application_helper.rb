module ApplicationHelper

  def titulo(titulo)
    if !titulo.empty?
      content_for :titulo, titulo + " - " + Rails.application.class.parent.to_s # nome do app
    else
      content_for :titulo, Rails.application.class.parent.to_s
    end
  end

end
