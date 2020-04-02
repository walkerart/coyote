Coyote::Application.config.secret_key_base = Credentials.fetch(:secret_key_base) do
  abort("Please set `secret_key_base` in the app's encrypted credentials")
end
