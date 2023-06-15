require "rails_helper"

describe "Homepage", :admin do
  let!(:processes_feed) { create(:widget_feed, kind: "processes") }
  before { Setting["homepage.widgets.feeds.processes"] = false }

  scenario "Processes" do
    5.times { create(:legislation_process, tag_list: ["ParticipaciónCiudadana"]) }
    4.times { create(:legislation_process, tag_list: ["ConsultaPrevia"]) }

    visit admin_homepage_path

    within("#widget_feed_#{processes_feed.id}") do
      select "3", from: "widget_feed_limit"
      click_button "No"

      expect(page).to have_button "Yes"
    end

    visit root_path

    within ".feed-processes", text: "Consulta Previa" do
      expect(page).to have_css(".feed-item", count: 3)
    end

    within ".feed-processes", text: "Participación Ciudadana" do
      expect(page).to have_css(".feed-item", count: 3)
    end
  end
end
