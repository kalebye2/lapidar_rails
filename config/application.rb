require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Lapidar
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # carregar biblioteca
    config.eager_load_paths += %W(#{config.root}/lib)

    # talvez no futuro configurar isto direito
    config.time_zone = 'Brasilia'
    config.active_record.default_timezone = :local
    config.beginning_of_week = :sunday

    config.i18n.default_locale = :pt

    # nome da aplicação
    config.app_name = "Nossa clínica"
    config.app_icon = ""

    # dados da clínica
    config.clinica_nome = "Nossa Clínica"
    config.clinica_endereco_logradouro = "Rua dos Bobos"
    config.clinica_endereco_num = "0"
    config.clinica_cidade = "Curitiba"
    config.clinica_estado = "Paraná"
    config.clinica_pais = "Brasil"
    config.clinica_fone = "(41) 9 9999-9999" # do jeito que vai aparecer na aplicação
  end
end
