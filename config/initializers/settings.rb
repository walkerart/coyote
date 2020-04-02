# Generic settings
Rails.application.configure do
  config.x.site_name = Credentials.fetch(:app, :name) { "Coyote" }
  config.x.host_name = Credentials.fetch(:app, :host) { "coyote.example.org" }
  config.x.project_url = Credentials.fetch(:app, :project_url) { "https://coyote.pics" }
  config.x.dashboard_top_items_queue_size = 10
  config.x.default_email_from_address = Credentials.fetch(:mailer, :sender) { "support@#{config.x.host_name}" }
  config.x.resource_api_page_size = ENV.fetch("COYOTE_API_RESOURCE_PAGE_SIZE", 50).to_i
  config.x.api_mime_type_template = ENV.fetch("COYOTE_API_MIME_TYPE_TEMPLATE", "application/vnd.coyote.%<version>s+json")
  config.x.maximum_login_attempts = ENV.fetch("COYOTE_MAXIMUM_LOGIN_ATTEMPTS", 5).to_i
  config.x.default_representation_language = ENV.fetch("COYOTE_DEFAULT_REPRESENTATION_LANGUAGE", "en")
  config.x.unlock_user_accounts_after_this_many_minutes = ENV.fetch("COYOTE_UNLOCK_USER_ACCOUNTS_AFTER_THIS_MANY_MINUTES", 10).to_i

  config.action_mailer.default_url_options = {host: config.x.host_name}
end
