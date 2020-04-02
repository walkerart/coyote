# Configure SMTP
Rails.application.configure do
  config.action_mailer.smtp_settings = {
    user_name:            Credentials.dig(:mailer, :user),
    password:             Credentials.dig(:mailer, :password),
    domain:               Credentials.dig(:mailer, :domain),
    address:              Credentials.dig(:mailer, :host),
    port:                 Credentials.dig(:mailer, :port).to_i,
    authentication:       Credentials.dig(:mailer, :authentication),
    enable_starttls_auto: Credentials.dig(:mailer, :enable_starttls_auto),
  }
end
