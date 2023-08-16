module Types
  class LegislationProposalType < Types::BaseObject
    alias_method :proposal, :object

    field :cached_votes_down, Integer, null: true
    field :cached_votes_total, Integer, null: true
    field :cached_votes_up, Integer, null: true
    field :comments_count, Integer, null: true
    field :comments, Types::CommentType.connection_type, null: true
    field :description, String, null: true
    field :id, ID, null: false
    field :link, String, null: false
    field :process, Types::LegislationProcessType, null: true
    field :public_created_at, String, null: true
    field :retired_explanation, String, null: true
    field :retired_reason, String, null: true
    field :selected, Boolean, null: true
    field :summary, String, null: true
    field :title, String, null: false
    field :votes_count, Integer, null: true

    def votes_count
      proposal.cached_votes_total
    end

    def link
      legislation_process_proposal_url(proposal.process, proposal)
    end
  end
end
