require "rails_helper"

describe "Tenants", :admin, :seed_tenants do
  before { allow(Tenant).to receive(:default_host).and_return("localhost") }

  scenario "Hide and restore", :show_exceptions do
    create(:tenant, schema: "moon", name: "Moon")

    visit admin_tenants_path

    within("tr", text: "moon") do
      expect(page).to have_content "Yes"

      click_button "Enable tenant Moon"

      expect(page).to have_content "No"
      expect(page).not_to have_link "moon.lvh.me"
    end

    with_subdomain("moon") do
      visit root_path

      expect(page).to have_title "No encontrado"
    end

    visit admin_tenants_path

    within("tr", text: "moon") do
      expect(page).to have_content "No"

      click_button "Enable tenant Moon"

      expect(page).to have_content "Yes"
      expect(page).to have_link "moon.lvh.me"
    end

    with_subdomain("moon") do
      visit root_path

      expect(page).to have_link "Sign in"
      expect(page).not_to have_title "No encontrado"
    end
  end
end
