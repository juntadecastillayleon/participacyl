require "rails_helper"

describe Widget::Feed do
  describe "#processes" do
    let(:feed) { build(:widget_feed, kind: "processes", limit: 3) }

    it "returns past processes" do
      process = create(:legislation_process, :past)

      expect(feed.processes).to eq [process]
    end
  end
end
