require "rails_helper"

describe "Consul Schema", type: :graphql_api do
  include Rails.application.routes.url_helpers

  describe "Legislation" do
    describe "Process" do
      it "returns requested information" do
        process = create(:legislation_process, title: "Awesome process")
        proposal = create(:legislation_proposal, process: process)
        create(:vote, votable: proposal)
        create(:comment, commentable: proposal)

        query = "{
            legislation_processes {
              edges {
                node {
                  id, title, comments_count, proposals_count, votes_count, link
                }
              }
            }
          }"
        response = execute(query)
        ids = extract_fields(response, "legislation_processes", "id")
        titles = extract_fields(response, "legislation_processes", "title")
        proposals_count = extract_fields(response, "legislation_processes", "proposals_count")
        votes_count = extract_fields(response, "legislation_processes", "votes_count")
        comments_count = extract_fields(response, "legislation_processes", "comments_count")
        links = extract_fields(response, "legislation_processes", "link")

        expect(ids).to match_array [process.id.to_s]
        expect(titles).to match_array ["Awesome process"]
        expect(comments_count).to match_array [1]
        expect(proposals_count).to match_array [1]
        expect(votes_count).to match_array [1]
        expect(links).to match_array [legislation_process_url(process, host: "test")]
      end

      it "filters by tag name when given" do
        create(:legislation_process, tag_list: "Participation", title: "Participation process")
        create(:legislation_process, tag_list: "Consultation", title: "Consultation process")

        response = execute("{ legislation_processes { edges { node { title }}}}")
        titles = extract_fields(response, "legislation_processes", "title")

        expect(titles).to match_array ["Participation process", "Consultation process"]

        response = execute("{ legislation_processes(tag: \"Participation\") { edges { node { title }}}}")
        titles = extract_fields(response, "legislation_processes", "title")

        expect(titles).to match_array ["Participation process"]

        response = execute("{ legislation_processes(tag: \"Consultation\") { edges { node { title }}}}")
        titles = extract_fields(response, "legislation_processes", "title")

        expect(titles).to match_array ["Consultation process"]
      end
    end

    describe "Proposal" do
      it "returns requested information" do
        proposal = create(:legislation_proposal, title: "Awesome proposal")
        create(:vote, votable: proposal)
        create(:comment, commentable: proposal)

        query = "{ legislation_proposals { edges { node { id, title, comments_count, votes_count, link }}}}"
        response = execute(query)
        ids = extract_fields(response, "legislation_proposals", "id")
        titles = extract_fields(response, "legislation_proposals", "title")
        votes_count = extract_fields(response, "legislation_proposals", "votes_count")
        comments_count = extract_fields(response, "legislation_proposals", "comments_count")
        links = extract_fields(response, "legislation_proposals", "link")

        expect(ids).to match_array [proposal.id.to_s]
        expect(titles).to match_array ["Awesome proposal"]
        expect(comments_count).to match_array [1]
        expect(votes_count).to match_array [1]
        url = legislation_process_proposal_url(proposal.process, proposal, host: "test")
        expect(links).to match_array [url]
      end

      it "returns parent process" do
        process = create(:legislation_process, title: "Awesome processs",)
        proposal = create(:legislation_proposal, process: process)

        response = execute("{ legislation_proposal(id: #{proposal.id}) { process { title }}}")

        title = dig(response, "data.legislation_proposal.process.title")

        expect(title).to eq "Awesome processs"
      end
    end
  end

  describe "Comments" do
    it "only returns comments from proposals, debates, polls and legislation proprosals" do
      create(:comment, commentable: create(:proposal))
      create(:comment, commentable: create(:debate))
      create(:comment, commentable: create(:poll))
      create(:comment, commentable: create(:legislation_proposal))

      response = execute("{ comments { edges { node { commentable_type } } } }")
      received_commentables = extract_fields(response, "comments", "commentable_type")

      expect(received_commentables).to match_array ["Proposal", "Debate", "Poll", "Legislation::Proposal"]
    end
  end

  describe "Users" do
    let(:user) { create(:user) }

    it "returns requested information" do
      last_sign_in = DateTime.current
      user.update!(last_sign_in_at: last_sign_in)

      response = execute("{ user(id: #{user.id}) { last_sign_in_at } }")
      last_sign_in_at = dig(response, "data.user.last_sign_in_at")

      expect(last_sign_in_at).to eq I18n.l(last_sign_in, format: "%Y-%m-%dT%H:%M:%S%Z")
    end
  end
end
