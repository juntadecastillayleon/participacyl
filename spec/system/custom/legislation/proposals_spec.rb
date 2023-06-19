require "rails_helper"
require "sessions_helper"

describe "Legislation Proposals" do
  let(:proposal) { create(:legislation_proposal) }
  let(:admin) { create(:administrator) }
  let!(:admin_document) { create(:document, :admin, documentable: proposal, user: admin.user) }
  let!(:document) { create(:document, documentable: proposal) }

  describe "Show" do
    scenario "Mark documents uploaded by administrators" do
      visit legislation_process_proposal_path(proposal.process, proposal, locale: :es)

      within "#document_#{admin_document.id}" do
        expect(page).to have_content "Respuesta de la JCYL subido por el Administrador ##{admin_document.user.id}"
      end
      within "#document_#{document.id}" do
        expect(page).not_to have_content "Respuesta de la JCYL subido por el Administrador ##{document.user.id}"
      end
    end
  end
end
