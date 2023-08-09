require "rails_helper"

describe "Multitenancy", :seed_tenants do
  scenario "Shows the not found page when accessing a non-existing tenant", :show_exceptions do
    with_subdomain("jupiter") do
      visit root_path

      expect(page).to have_title "No encontrado"
    end
  end
end
