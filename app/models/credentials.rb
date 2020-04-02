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

  def fetch(*keys, &block)
    dig(*keys) || yield
  end
end

root_config = Rails.application.encrypted("config/credentials.yml.enc", key_path: "config/master.key", env_key: "RAILS_ROOT_KEY").config.symbolize_keys
env_config = Rails.application.credentials.config.symbolize_keys

Credentials = Credential.new(root_config.deep_merge(env_config))
