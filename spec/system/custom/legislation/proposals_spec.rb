require "rails_helper"
require "sessions_helper"

describe "Legislation Proposals" do
  let(:proposal) { create(:legislation_proposal) }

  describe "Show" do
    let(:admin) { create(:administrator) }
    let!(:admin_document) { create(:document, :admin, documentable: proposal, user: admin.user) }
    let!(:document) { create(:document, documentable: proposal) }

    scenario "Mark documents uploaded by administrators" do
      visit legislation_process_proposal_path(proposal.process, proposal, locale: :es)

      within "#document_#{admin_document.id}" do
        expect(page).to have_content "Respuesta de la JCYL subido por el Administrador ##{admin_document.user.id}"
      end
      within "#document_#{document.id}" do
        expect(page).not_to have_content "Respuesta de la JCYL subido por el Administrador ##{document.user.id}"
      end
    end

    describe "Summary" do
      it "Do not quote summary when description is not defined" do
        visit legislation_process_proposal_path(proposal.process, proposal)

        expect(page).not_to have_css "blockquote"
      end

      it "Summary quoted when description is defined" do
        proposal.update!(description: "Description for proposal")
        visit legislation_process_proposal_path(proposal.process, proposal)

        expect(page).to have_css "blockquote", count: 1
      end
    end
  end
end
