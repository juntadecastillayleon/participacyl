require "rails_helper"

describe "Admin collaborative legislation", :admin do
  context "Create" do
    scenario "Valid legislation process" do
      visit admin_root_path

      within("#side_menu") do
        click_link "Collaborative Legislation"
      end

      expect(page).not_to have_content "An example legislation process"

      click_link "New process"

      fill_in "Process Title", with: "An example legislation process"
      fill_in "Summary", with: "Summary of the process"
      fill_in "Description", with: "Describing the process"
      fill_in "Prompt", with: "What do you think about this legislation process?"

      base_date = Date.current

      within_fieldset text: "Draft phase" do
        check "Enabled"
        fill_in "Start", with: base_date - 3.days
        fill_in "End", with: base_date - 1.day
      end

      within_fieldset "Process" do
        fill_in "Start", with: base_date
        fill_in "End", with: base_date + 5.days
      end

      within_fieldset "Debate phase" do
        check "Enabled"
        fill_in "Start", with: base_date
        fill_in "End", with: base_date + 2.days
      end

      within_fieldset "Comments phase" do
        check "Enabled"
        fill_in "Start", with: base_date + 3.days
        fill_in "End", with: base_date + 5.days
      end

      check "legislation_process[draft_publication_enabled]"
      fill_in "Draft publication date", with: base_date + 3.days

      check "legislation_process[result_publication_enabled]"
      fill_in "Final result publication date", with: base_date + 7.days

      click_button "Create process"

      expect(page).to have_content "An example legislation process"
      expect(page).to have_content "Process created successfully"

      click_link "Click to visit"

      expect(page).to have_content "An example legislation process"
      expect(page).not_to have_content "Summary of the process"
      expect(page).to have_content "Describing the process"
      expect(page).to have_content "WHAT DO YOU THINK ABOUT THIS LEGISLATION PROCESS?"

      within(".legislation-process-list") do
        expect(page).to have_link text: "Debate"
        expect(page).to have_link text: "Comments"
      end

      visit legislation_processes_path

      expect(page).to have_content "An example legislation process"
      expect(page).to have_content "Summary of the process"
      expect(page).not_to have_content "Describing the process"
    end

    scenario "Default colors are present" do
      visit new_admin_legislation_process_path

      expect(find("#legislation_process_background_color").value).to eq "#f0f0f0"
      expect(find("#legislation_process_font_color").value).to eq "#222222"
    end
  end

  context "Update" do
    let!(:process) do
      create(:legislation_process,
             title: "An example legislation process",
             description: "Description of the process",
             prompt: "What do you think about this legislative process?")
    end

    scenario "Update fields" do
      visit edit_admin_legislation_process_path(process)

      fill_in "Process Title", with: "New title"
      fill_in "Description", with: "New description"
      fill_in "Prompt", with: "New prompt?"

      click_button "Save changes"

      expect(page).to have_content "Process updated successfully"

      click_link "Click to visit"

      expect(page).to have_content "New title"
      expect(page).to have_content "New description"
      expect(page).to have_content "NEW PROMPT?"
    end

    scenario "Do not show the first paragraph of description when remove summary text" do
      visit edit_admin_legislation_process_path(process)

      fill_in "Summary", with: ""
      click_button "Save changes"

      expect(page).to have_content "Process updated successfully"

      visit legislation_processes_path

      expect(page).not_to have_content "Summarizing the process"
      expect(page).not_to have_content "Description of the process"
    end
  end
end
