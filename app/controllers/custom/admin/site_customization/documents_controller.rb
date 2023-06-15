require_dependency Rails.root.join("app", "controllers", "admin", "site_customization", "documents_controller").to_s

class Admin::SiteCustomization::DocumentsController < Admin::SiteCustomization::BaseController
  private

    alias_method :consul_initialize_document, :initialize_document

    def initialize_document
      document = consul_initialize_document
      document.documentable_id = params[:document][:documentable_id]
      document.documentable_type = "Legislation::Proposal"
      document
    end
end
