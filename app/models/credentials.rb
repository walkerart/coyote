class Credential < OpenStruct
  def initialize(attributes = {})
    super {}
    attributes.each do |key, value|
      send("#{key}=", value.is_a?(Hash) ? Credential.new(value) : value)
    end
  end

  def dig(*keys)
    value = self
    keys.each do |key|
      value = value.send(key)
      break if value.blank?
    end

    value
  end

  def fetch(*keys)
    dig(*keys) || yield
  end
end

# Credentials are applied in the following order:
# 1. Base
# 2. RAILS_ENV specific
# 3. Staging specific (if a STAGING flag is given)
base_config = Rails.application.encrypted("config/credentials.yml.enc", key_path: "config/master.key", env_key: "RAILS_BASE_KEY").config.symbolize_keys
env_config = Rails.application.credentials.config.symbolize_keys
staging_config = ENV["STAGING"] ?
  Rails.application.encrypted("config/credentials/staging.yml.enc", key_path: "config/credentials/staging.key", env_key: "RAILS_STAGING_KEY").config.symbolize_keys :
  {}

env_config = env_config.deep_merge(staging_config)

Credentials = Credential.new(base_config.deep_merge(env_config))
