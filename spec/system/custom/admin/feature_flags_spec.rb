require "rails_helper"

describe "Admin feature flags", :admin do
  before do
    Setting["process.budgets"] = true
  end

  scenario "Disable a participatory process", :show_exceptions do
    budget = create(:budget)

    visit admin_settings_path
    within("#settings-tabs") { click_link "Participation processes" }

    within("tr", text: "Participatory budgeting") do
      click_button "Yes"

      expect(page).to have_button "No"
    end

    within("#side_menu") do
      expect(page).not_to have_link "Participatory budgets"
    end

    visit budget_path(budget)

    expect(page).to have_title "Prohibido"

    visit admin_budgets_path

    expect(page).to have_current_path admin_budgets_path
    expect(page).to have_title "Prohibido"
  end
end
