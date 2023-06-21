require_dependency Rails.root.join("app", "models", "setting").to_s

class Setting
  class << self
    alias_method :consul_defaults, :defaults

    # Change this code when you'd like to add settings that aren't
    # already present in the database. These settings will be added when
    # first installing CONSUL, when deploying code with Capistrano, or
    # when manually executing the `settings:add_new_settings` task.
    #
    # If a setting already exists in the database, changing its value in
    # this file will have no effect unless the task `rake db:seed` is
    # invoked or the method `Setting.reset_defaults` is executed. Doing
    # so will overwrite the values of all existing settings in the
    # database, so use with care.
    #
    # The tests in the spec/ folder rely on CONSUL's default settings, so
    # it's recommended not to change the default settings in the test
    # environment.
    def defaults
      if Rails.env.test?
        consul_defaults
      else
        consul_defaults.merge({
          # Overwrite default CONSUL settings or add new settings here
          comments_body_max_length: 12000,
          "feature.facebook_login": false,
          "feature.google_login": false,
          "feature.twitter_login": false,
          "feature.signature_sheets": false,
          "feature.sdg": false,
          "homepage.widgets.feeds.debates": false,
          "homepage.widgets.feeds.proposals": false,
          mailer_from_name: "Participa Castilla y León",
          mailer_from_address: "noreply@participacyl.es",
          org_name: "Junta de Castilla y León",
          "process.budgets": false,
          "process.debates": false,
          "process.polls": false,
          "process.proposals": false,
          proposal_code_prefix: "CYL",
          "uploads.documents.content_types": %w[application/pdf
                                                application/msword
                                                application/vnd.openxmlformats-officedocument.wordprocessingml.document
                                                application/x-ole-storage application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
                                                text/plain
                                                application/zip
                                                image/jpeg
                                                image/png
                                                image/gif].join(" "),
          "uploads.documents.max_amount": 10,
          "uploads.documents.max_size": 50,
          "uploads.images.content_types": "image/jpeg image/png image/gif",
          url: "http://participacyl.es"
        })
      end
    end

    def mime_types
      {
        "images" => {
          "jpg"  => "image/jpeg",
          "png"  => "image/png",
          "gif"  => "image/gif"
        },
        "documents" => {
          "pdf"  => "application/pdf",
          "doc"  => "application/msword",
          "docx" => "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
          "xls"  => "application/x-ole-storage",
          "xlsx" => "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
          "csv"  => "text/plain",
          "zip"  => "application/zip",
          "jpg"  => "image/jpeg",
          "png"  => "image/png",
          "gif"  => "image/gif"
        }
      }
    end
  end
end
