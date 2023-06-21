require "open-uri"

namespace :import_data do
  desc "xxxx"
  task import: :environment do
    ActiveRecord::Base.class_eval do
      class << self
        def skip_callbacks(*types)
          types = [:save, :create, :update, :destroy, :touch] if types.empty?
          deactivate_callbacks(types)
          yield.tap do
            activate_callbacks(types)
          end
        end

        def deactivate_callbacks(types)
          types.each do |type|
            name = :"_run_#{type}_callbacks"
            alias_method(:"_deactivated_#{name}", name)
            define_method(name) { |&block| block.call }
          end
        end

        def activate_callbacks(types)
          types.each do |type|
            name = :"_run_#{type}_callbacks"
            alias_method(name, :"_deactivated_#{name}")
            undef_method(:"_deactivated_#{name}")
          end
        end

        def force_create(attributes = nil)
          new(attributes).tap { |record| skip_callbacks { record.save(validate: false) } }
        end
      end
    end

    ActiveRecord::Base.transaction do
      processes = JSON.parse(File.read(Rails.root.join("lib", "tasks", "data.json")))["forums"]

      processes.each do |process|
        start_date = Date.parse(process["created_at"])
        end_date = process["is_open"] ? 1.year.from_now.to_date : Date.parse(process["updated_at"])
        publication_enabled = !process["is_open"] && process["suggestions"].present?
        tag = if process["tag"] == "Participa"
                "ParticipaciónCiudadana"
              else
                process["tag"]
              end

        legislation_process = Legislation::Process.create!(
          title: process["name"],
          description: ReverseMarkdown.convert(process["welcome_message"]),
          prompt: process["prompt"],
          start_date: start_date,
          end_date: end_date,
          proposals_phase_enabled: true,
          proposals_phase_start_date: start_date,
          proposals_phase_end_date: end_date,
          result_publication_date: end_date,
          result_publication_enabled: publication_enabled,
          published: true,
          tag_list: [tag]
        )
        process["suggestions"]&.each do |suggestion|
          author = User.find_or_initialize_by(email: "#{suggestion["created_by"]}a@consul.dev")
          persisted = author.persisted?
          author.username = "@#{suggestion["created_name"]}" unless persisted
          author.terms_of_service = "1"
          author.skip_password_validation = true
          author.skip_confirmation_notification!
          author.save!
          author.update!(username: "#{author.username}##{author.id}".delete_prefix("@")) unless persisted

          proposal = Legislation::Proposal.create!(
            title: suggestion["title"],
            summary: suggestion["body"],
            terms_of_service: "1",
            process: legislation_process,
            author: author,
            created_at: DateTime.parse(suggestion["created_at"]),
            selected: true
          )
          suggestion["votes_count"].times do
            user = User.force_create(username: nil,
                                     email: nil,
                                     terms_of_service: "1",
                                     erased_at: DateTime.current)
            Vote.force_create(votable: proposal, voter: user, vote_flag: true)
          end
          proposal.update_cached_votes

          suggestion["attachments"]&.each do |attachment|
            document = Document.new(documentable: proposal,
                                    user: author,
                                    title: attachment["file_name"],
                                    created_at: DateTime.parse(attachment["created_at"]))
            begin
              file = URI.parse(attachment["url"]).open
              next if file.content_type == "text/html"

              document.attachment.attach(io: file, filename: attachment["file_name"])
              document.save!
            rescue OpenURI::HTTPError
              next
            end
          end

          if suggestion["status_updates"].present?
            admin = Administrator.first
            Comment.create!(commentable: proposal,
                           user: admin.user,
                           administrator_id: admin.id,
                           body: suggestion["status_updates"]["body"],
                           created_at: DateTime.parse(suggestion["status_updates"]["created_at"]))
            suggestion["status_updates"]["attachments"]&.each do |attachment|
              document = Document.new(documentable: proposal,
                                      user: admin.user,
                                      admin: true,
                                      title: attachment["file_name"],
                                      created_at: DateTime.parse(attachment["created_at"]))
              begin
                file = URI.parse(attachment["url"]).open
                next if file.content_type == "text/html"

                document.attachment.attach(io: file, filename: attachment["file_name"])
                document.save!
              rescue OpenURI::HTTPError
                next
              end
            end
          end
        end

        puts "Process #{process["id"]} imported"
      end
    end
  end
end
