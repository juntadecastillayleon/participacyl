require "rails_helper"

describe Legislation::Process do
  it "overwrites CONSUL's default background color" do
    expect(build(:legislation_process).background_color).to eq "#f0f0f0"
  end
end
