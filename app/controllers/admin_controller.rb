class AdminController < ApplicationController
  before_action :validar_usuario

  ActiveRecord::Base.connection.tables.each do |table_name|
    Admin.const_set "#{table_name.camelcase}Controller", Class.new(ApplicationController) do
      define_method :index do
      end
      
      define_method :teste do
        12
      end
    end
  end

  def self.paths
    self.action_methods.subtract(ApplicationController.action_methods)
  end

  def index

  end

  # def acompanhamento_finalizacao_motivos
  # end

  self.paths.each do |path|
    define_singleton_method path do
      render partial: "admin/table-display", class_name: path.classify
    end
  end

  def acompanhamento_tipos
    render partial: "admin/table-display", class_name: "AcompanhamentoTipo"
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

  def atendimentos
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
      erro403
    end
  end
end
