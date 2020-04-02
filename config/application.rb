require_relative "boot"

require "rails"

# Pick the frameworks you want:
require "active_model/railtie"
# require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Ensure Ransack uses Simpleform: https://github.com/activerecord-hackery/ransack#using-simpleform
ENV["RANSACK_FORM_BUILDER"] = "::SimpleForm::FormBuilder"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Coyote
  class Application < Rails::Application
    config.before_configuration do
      config.sass.preferred_syntax = :sass
    end

    config.load_defaults "5.2"

    config.eager_load_paths << Rails.root.join("lib") # http://blog.arkency.com/2014/11/dont-forget-about-eager-load-when-extending-autoload/

    config.active_record.schema_format = :sql

    config.action_controller.per_form_csrf_tokens = true
    config.action_controller.forgery_protection_origin_check = true

    config.active_record.belongs_to_required_by_default = true

    # see https://github.com/elabs/pundit#rescuing-a-denied-authorization-in-rails
    config.action_dispatch.rescue_responses["Pundit::NotAuthorizedError"] = :forbidden
    config.action_dispatch.rescue_responses["Coyote::SecurityError"] = :forbidden

    config.generators do |g|
      g.stylesheets false
      g.javascripts false
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
      g.template_engine :haml
      g.factory_bot dir: Rails.root.join("spec", "factories").to_s
    end

    # Prevent Rails from messing up generated URLs in the API
    config.active_support.escape_html_entities_in_json = false
  end
end
