require "rails_helper"

describe Legislation::Proposal do
  let(:proposal) { build(:legislation_proposal) }

  it "is valid with title length less than 140 characters" do
    proposal.title = "Title example with less than 140 characters to ensure that we've " \
                     "correctly increased from 80 to 140 characters the title length validation"

    expect(proposal).to be_valid
  end

  it "is invalid with title length more than 140 characters" do
    proposal.title = "Title example with more than 140 characters to ensure that we have " \
                     "correctly increased from 80 to 140 characters the title length validation."

    expect(proposal).not_to be_valid
  end

  it "is valid without a summary", :consul do
    proposal.summary = nil
    expect(proposal).to be_valid
  end
end
