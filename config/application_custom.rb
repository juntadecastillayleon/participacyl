module Consul
  class Application < Rails::Application
    config.i18n.default_locale = :es
    config.available_locales = ["es"]
  end
end
