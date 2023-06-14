require "rails_helper"

describe "Tags" do
  scenario "Filter from index" do
    create(:legislation_process, tag_list: "ConsultaPrevia", title: "¿Qué opinas? ¡Participa ahora!")
    create(:legislation_process, tag_list: "ParticipaciónCiudadana", title: "¡Tu voto cuenta!")

    visit legislation_processes_path

    within ".legislation", text: "¡Participa ahora!" do
      expect(page).to have_content "ConsultaPrevia"
      expect(page).not_to have_content "ParticipaciónCiudadana"
    end

    within ".legislation", text: "¡Tu voto cuenta!" do
      expect(page).to have_content "ParticipaciónCiudadana"
      expect(page).not_to have_content "ConsultaPrevia"
    end

    within("aside") { click_link "ParticipaciónCiudadana" }

    expect(page).not_to have_content "¡Participa ahora!"
    expect(page).to have_content "¡Tu voto cuenta!"
  end
end
