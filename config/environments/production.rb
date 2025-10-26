require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot for better performance and memory savings.
  config.eager_load = true

  # Full error reports are disabled.
  config.consider_all_requests_local = false

  # Turn on fragment caching in view templates.
  config.action_controller.perform_caching = true

  # =================================================================
  # AJUSTES PARA O RENDER
  # =================================================================

  # 1. Servir arquivos estáticos (CSS, JS, imagens) a partir do Rails.
  #    O Render precisa disso para que os assets funcionem.
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?

  # 2. Desabilitar compilação de assets em tempo real.
  #    Os assets serão pré-compilados durante o build no Render.
  config.assets.compile = false

  # 3. Cache de assets (seu código já tinha, mantido por ser bom).
  config.public_file_server.headers = { "cache-control" => "public, max-age=#{1.year.to_i}" }

  # 4. Configurar Active Storage para usar o serviço de produção.
  #    Isso vai usar o disco persistente do Render (se configurado em plano pago).
  config.active_storage.service = :production

  # 5. Forçar SSL para segurança.
  config.force_ssl = true

  # 6. Permitir que a aplicação responda ao domínio do Render.
  #    A variável de ambiente HOST será configurada no painel do Render.
  config.hosts << ENV.fetch("HOST") if ENV["HOST"].present?

  # =================================================================
  # FIM DOS AJUSTES PARA O RENDER
  # =================================================================

  # Log para STDOUT (padrão para plataformas de deploy).
  config.log_tags = [ :request_id ]
  config.logger   = ActiveSupport::TaggedLogging.logger(STDOUT)

  # Nível do log.
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Não poluir os logs com health checks.
  config.silence_healthcheck_path = "/up"

  # Não mostrar avisos de "deprecation".
  config.active_support.report_deprecations = false

  # =================================================================
  # Simplificado para o deploy inicial.
  # As linhas abaixo precisam estar comentadas para evitar os erros
  # de 'database not configured' que você viu.
  # =================================================================
  # config.cache_store = :solid_cache_store
  # config.active_job.queue_adapter = :solid_queue
  # config.solid_queue.connects_to = { database: { writing: :queue } }
  # =================================================================

  # Configuração de Action Mailer (se for usar envio de emails).
  # Lembre-se de configurar as credenciais e o host correto.
  config.action_mailer.default_url_options = { host: ENV.fetch("HOST", "localhost") }
  # config.action_mailer.raise_delivery_errors = false

  # I18n fallbacks.
  config.i18n.fallbacks = true

  # Não criar dump do schema após migrations em produção.
  config.active_record.dump_schema_after_migration = false

  # Apenas o :id nos logs de inspeção do Active Record.
  config.active_record.attributes_for_inspect = [ :id ]

  # Removido, pois a linha 'config.hosts' acima já lida com isso de forma mais flexível.
  # config.host_authorization = { exclude: ->(request) { request.path == "/up" } }
end
