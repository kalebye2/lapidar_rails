class AdminController < ApplicationController
  before_action :validar_usuario

  def self.paths
    self.action_methods.subtract(ApplicationController.action_methods)
  end

  def index
  end

  def acompanhamento_finalizacao_motivos
  end

  def acompanhamento_tipos
  end

  def atendimento_locais
  end

  def atendimento_local_tipos
  end

  def atendimento_modalidades
  end

  def atendimento_plataformas
  end

  def atendimento_tipos
  end

  def civil_estados
  end

  def profissional_funcoes
  end

  def usuarios
  end

  private

  def validar_usuario
    if usuario_atual.nil? || !usuario_atual.informatica?
      render file: "#{Rails.root}/public/404.html", status: 403
    end
  end
end
