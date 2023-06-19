require "rails_helper"

describe "Documents", :admin do
  let(:legislation_proposal) { create(:legislation_proposal, id: "555") }

  scenario "Index" do
    3.times { create(:document, :admin, documentable: legislation_proposal) }
    1.times { create(:document) }

    document = Document.first
    url = polymorphic_path(document.attachment)

    visit admin_site_customization_documents_path(locale: :es)

    expect(page).to have_content "Hay 3 documentos"
    expect(page).to have_content "ID Propuesta"
    within "#document_#{document.id}" do
      expect(page).to have_link document.title, href: url
      expect(page).to have_content "555"
    end
  end

  scenario "Create" do
    visit new_admin_site_customization_document_path(locale: :es)

    attach_file("document_attachment", file_fixture("logo.pdf"))
    fill_in "ID de la Propuesta", with: "555"
    click_button "Subir documento"

    expect(page).to have_content "Documento creado correctamente"
    expect(page).to have_content "555"
    expect(page).to have_link "logo.pdf"
  end
end
