require "rails_helper"

describe "Moderate comments" do
  context "when its commentable is hidden" do
    scenario "show a text that the commentable is hidden and do not show the link" do
      moderator = create(:moderator)
      hidden_proposal = create(:legislation_proposal, :hidden, title: "Proposal with spam comment")
      create(:comment, commentable: hidden_proposal, body: "SPAM comment", flags_count: 2)

      login_as(moderator.user)
      visit moderation_comments_path

      expect(page).to have_content "(Hidden proposal: Proposal with spam comment)"
      expect(page).not_to have_link "Proposal with spam comment"
    end
  end
end
