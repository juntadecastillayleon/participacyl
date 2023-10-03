require "rails_helper"

describe "Home" do
  before { create(:widget_feed, kind: "processes", limit: 10) }

  context "Processes widget feed" do
    scenario "Show opened proceses first" do
      %w[ConsultaPrevia ParticipaciónCiudadana].each do |category|
        create(:legislation_process, title: "One week process",
                                     tag_list: category,
                                     start_date: 1.day.ago,
                                     end_date: 1.week.from_now)
        create(:legislation_process, title: "Two weeks process",
                                     tag_list: category,
                                     start_date: 1.day.ago,
                                     end_date: 2.weeks.from_now)
        create(:legislation_process, title: "One month process",
                                     tag_list: category,
                                     start_date: 1.day.ago,
                                     end_date: 1.month.from_now)
      end

      visit root_path(locale: :es)

      within ".feed-processes", text: "Consultas previas" do
        expect(page).to have_css(".open", count: 3)
        expect("One week process").to appear_before("Two weeks process")
        expect("Two weeks process").to appear_before("One month process")
      end
      within ".feed-processes", text: "Procesos de participación ciudadana" do
        expect(page).to have_css(".open", count: 3)
        expect("One week process").to appear_before("Two weeks process")
        expect("Two weeks process").to appear_before("One month process")
      end
    end

    scenario "When opened processes do not reach the widget feed limit it shows past processes" do
      %w[ConsultaPrevia ParticipaciónCiudadana].each do |category|
        create(:legislation_process, title: "One week process",
                                     tag_list: category,
                                     start_date: 1.day.ago,
                                     end_date: 1.week.from_now)
        create(:legislation_process, title: "Two weeks process",
                                     tag_list: category,
                                     start_date: 1.day.ago,
                                     end_date: 2.weeks.from_now)

        create(:legislation_process, title: "Recently closed project",
                                     tag_list: category,
                                     start_date: 1.week.ago,
                                     end_date: 1.day.ago)
        create(:legislation_process, title: "Older closed project",
                                     tag_list: category,
                                     start_date: 2.weeks.ago,
                                     end_date: 1.week.ago)
      end

      visit root_path(locale: :es)

      within ".feed-processes", text: "Consultas previas" do
        expect("One week process").to appear_before("Two weeks process")
        expect("Two weeks process").to appear_before("Recently closed project")
        expect("Recently closed project").to appear_before("Older closed project")
      end
      within ".feed-processes", text: "Procesos de participación ciudadana" do
        expect("One week process").to appear_before("Two weeks process")
        expect("Two weeks process").to appear_before("Recently closed project")
        expect("Recently closed project").to appear_before("Older closed project")
      end
    end
  end
end
