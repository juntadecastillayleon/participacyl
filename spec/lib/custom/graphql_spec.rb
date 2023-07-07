require "rails_helper"

describe "Consul Schema", type: :graphql_api do
  describe "Legislation" do
    describe "Process" do
      it "returns requested information" do
        process = create(:legislation_process, title: "Awesome process")
        proposal = create(:legislation_proposal, process: process)
        create(:vote, votable: proposal)
        create(:comment, commentable: proposal)

        response = execute("{ legislation_processes { edges { node { id, title, comments_count, proposals_count, votes_count }}}}")
        ids = extract_fields(response, "legislation_processes", "id")
        titles = extract_fields(response, "legislation_processes", "title")
        proposals_count = extract_fields(response, "legislation_processes", "proposals_count")
        votes_count = extract_fields(response, "legislation_processes", "votes_count")
        comments_count = extract_fields(response, "legislation_processes", "comments_count")

        expect(ids).to match_array [process.id.to_s]
        expect(titles).to match_array ["Awesome process"]
        expect(comments_count).to match_array [1]
        expect(proposals_count).to match_array [1]
        expect(votes_count).to match_array [1]
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
  end
end
