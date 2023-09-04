require "rails_helper"

describe Widget::Feed do
  let(:feed) { build(:widget_feed, kind: "processes", limit: 10) }

  describe "#consultation_open_processes" do
    it "returns open processes tagged with the custom category `ConsultaPrevia`" do
      create(:legislation_process, :past, tag_list: "ConsultaPrevia")
      create(:legislation_process, :open)
      open_process = create(:legislation_process, :open, tag_list: "ConsultaPrevia")

      expect(feed.consultation_open_processes).to eq [open_process]
    end

    it "returns open processes with the closest end dates first" do
      create(:legislation_process, :past, tag_list: "ConsultaPrevia")
      open_process_day = create(:legislation_process, tag_list: "ConsultaPrevia",
                                                      start_date: 1.day.ago,
                                                      end_date: 1.day.from_now)
      open_process_week = create(:legislation_process, tag_list: "ConsultaPrevia",
                                                       start_date: 1.week.ago,
                                                       end_date: 1.week.from_now)
      open_process_month = create(:legislation_process, tag_list: "ConsultaPrevia",
                                                        start_date: 1.month.ago,
                                                        end_date: 1.month.from_now)

      processes = [open_process_day, open_process_week, open_process_month]
      expect(feed.consultation_open_processes).to eq(processes)
    end
  end

  describe "#consultation_past_processes" do
    it "returns past processes tagged with the custom category `ConsultaPrevia`" do
      past_process = create(:legislation_process, :past, tag_list: "ConsultaPrevia")
      create(:legislation_process, :past)
      create(:legislation_process, :open, tag_list: "ConsultaPrevia")

      expect(feed.consultation_past_processes).to eq [past_process]
    end

    it "returns recently closed processes first" do
      create(:legislation_process, :open, tag_list: "ConsultaPrevia")
      past_process_day = create(:legislation_process, tag_list: "ConsultaPrevia",
                                                      start_date: 1.month.ago,
                                                      end_date: 1.day.ago)
      past_process_week = create(:legislation_process, tag_list: "ConsultaPrevia",
                                                       start_date: 1.month.ago,
                                                       end_date: 1.week.ago)
      past_process_month = create(:legislation_process, tag_list: "ConsultaPrevia",
                                                        start_date: 2.months.ago,
                                                        end_date: 1.month.ago)

      processes = [past_process_day, past_process_week, past_process_month]
      expect(feed.consultation_past_processes).to eq(processes)
    end
  end

  describe "#participation_open_processes" do
    it "returns open processes tagged with the custom category `ParticipaciónCiudadana`" do
      create(:legislation_process, :past, tag_list: "ParticipaciónCiudadana")
      create(:legislation_process, :open)
      open_process = create(:legislation_process, :open, tag_list: "ParticipaciónCiudadana")

      expect(feed.participation_open_processes).to eq [open_process]
    end

    it "returns open processes with the closest end dates first" do
      create(:legislation_process, :past, tag_list: "ParticipaciónCiudadana")
      open_process_day = create(:legislation_process, tag_list: "ParticipaciónCiudadana",
                                                      start_date: 1.day.ago,
                                                      end_date: 1.day.from_now)
      open_process_week = create(:legislation_process, tag_list: "ParticipaciónCiudadana",
                                                       start_date: 1.week.ago,
                                                       end_date: 1.week.from_now)
      open_process_month = create(:legislation_process, tag_list: "ParticipaciónCiudadana",
                                                        start_date: 1.month.ago,
                                                        end_date: 1.month.from_now)

      processes = [open_process_day, open_process_week, open_process_month]
      expect(feed.participation_open_processes).to eq(processes)
    end
  end

  describe "#participation_past_processes" do
    it "returns past processes tagged with the custom category `ParticipaciónCiudadana`" do
      past_process = create(:legislation_process, :past, tag_list: "ParticipaciónCiudadana")
      create(:legislation_process, :past)
      create(:legislation_process, :open, tag_list: "ParticipaciónCiudadana")

      expect(feed.participation_past_processes).to eq [past_process]
    end

    it "returns recently closed processes first" do
      create(:legislation_process, :open, tag_list: "ParticipaciónCiudadana")
      past_process_day = create(:legislation_process, tag_list: "ParticipaciónCiudadana",
                                                      start_date: 1.month.ago,
                                                      end_date: 1.day.ago)
      past_process_week = create(:legislation_process, tag_list: "ParticipaciónCiudadana",
                                                       start_date: 1.month.ago,
                                                       end_date: 1.week.ago)
      past_process_month = create(:legislation_process, tag_list: "ParticipaciónCiudadana",
                                                        start_date: 2.months.ago,
                                                        end_date: 1.month.ago)

      processes = [past_process_day, past_process_week, past_process_month]
      expect(feed.participation_past_processes).to eq(processes)
    end
  end
end
