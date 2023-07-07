require_dependency Rails.root.join("app", "graphql", "types", "base_object")

module Types
  class BaseObject
    include ActionController::UrlFor
    include Rails.application.routes.url_helpers

    # Needed by ActionController::UrlFor to extract the host, port,
    # protocol etc. from the current request
    def request
      context[:request]
    end

    # Needed by Rails.application.routes.url_helpers, it will then use the
    # url_options defined by ActionController::UrlFor
    def default_url_options
      {}
    end
  end
end
