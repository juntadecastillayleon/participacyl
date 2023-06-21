require "rails_helper"

describe "Advanced search" do
  scenario "Search legislation processes"do
    create(:legislation_process, :open, title: "Open and interesting")
    create(:legislation_process, :open, title: "Also open and also interesting")
    create(:legislation_process, :open, title: "Open and ordinary")
    create(:legislation_process, :past, title: "Past and interesting")
    create(:legislation_process, :past, title: "Past and ordinary")

    visit legislation_processes_path

    expect(page).to have_content "Open and interesting"
    expect(page).to have_content "Also open and also interesting"
    expect(page).to have_content "Open and ordinary"
    expect(page).not_to have_content "Past and interesting"
    expect(page).not_to have_content "Past and ordinary"

    click_button "Advanced search"
    fill_in "With the text", with: "Interesting"
    click_button "Filter"

    expect(page).not_to have_content "Open and ordinary"
    expect(page).not_to have_content "Past and interesting"
    expect(page).not_to have_content "Past and ordinary"
    expect(page).to have_content "Open and interesting"
    expect(page).to have_content "Also open and also interesting"

    click_link "Past"

    expect(page).not_to have_content "Open and interesting"
    expect(page).not_to have_content "Also open and also interesting"
    expect(page).not_to have_content "Open and ordinary"
    expect(page).not_to have_content "Past and ordinary"
    expect(page).to have_content "Past and interesting"
  end
end
