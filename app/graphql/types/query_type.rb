module Types
  class QueryType < Types::BaseObject
    field :comments, Types::CommentType.connection_type, "Returns all comments", null: false
    field :comment, Types::CommentType, "Returns comment for ID", null: false do
      argument :id, ID, required: true, default_value: false
    end

    field :debates, Types::DebateType.connection_type, "Returns all debates", null: false
    field :debate, Types::DebateType, "Returns debate for ID", null: false do
      argument :id, ID, required: true, default_value: false
    end

    field :geozones, Types::GeozoneType.connection_type, "Returns all geozones", null: false
    field :geozone, Types::GeozoneType, "Returns geozone for ID", null: false do
      argument :id, ID, required: true, default_value: false
    end

    field :legislation_processes, Types::LegislationProcessType.connection_type, "Returns all legislation processes", null: false do
      argument :tag, String, required: false, default_value: nil
    end
    field :legislation_process, Types::LegislationProcessType, "Returns legislation process for ID", null: false do
      argument :id, ID, required: true, default_value: false
    end

    field :legislation_proposals, Types::LegislationProposalType.connection_type, "Returns all legislation proposals", null: false
    field :legislation_proposal, Types::LegislationProposalType, "Returns legislation proposal for ID", null: false do
      argument :id, ID, required: true, default_value: false
    end

    field :proposals, Types::ProposalType.connection_type, "Returns all proposals", null: false
    field :proposal, Types::ProposalType, "Returns proposal for ID", null: false do
      argument :id, ID, required: true, default_value: false
    end

    field :proposal_notifications, Types::ProposalNotificationType.connection_type, "Returns all proposal notifications", null: false
    field :proposal_notification, Types::ProposalNotificationType, "Returns proposal notification for ID", null: false do
      argument :id, ID, required: true, default_value: false
    end

    field :tags, Types::TagType.connection_type, "Returns all tags", null: false
    field :tag, Types::TagType, "Returns tag for ID", null: false do
      argument :id, ID, required: true, default_value: false
    end

    field :users, Types::UserType.connection_type, "Returns all users", null: false
    field :user, Types::UserType, "Returns user for ID", null: false do
      argument :id, ID, required: true, default_value: false
    end

    field :votes, Types::VoteType.connection_type, "Returns all votes", null: false
    field :vote, Types::VoteType, "Returns vote for ID", null: false do
      argument :id, ID, required: true, default_value: false
    end

    def comments
      Comment.public_for_api
    end

    def comment(id:)
      Comment.find(id)
    end

    def debates
      Debate.public_for_api
    end

    def debate(id:)
      Debate.find(id)
    end

    def geozones
      Geozone.public_for_api
    end

    def geozone(id:)
      Geozone.find(id)
    end

    def legislation_processes(tag: nil)
      processes = Legislation::Process.public_for_api
      processes = processes.joins(:tags).where(tags: { name: tag }) if tag.present?
      processes
    end

    def legislation_process(id:)
      Legislation::Process.find(id)
    end

    def legislation_proposals
      Legislation::Proposal.public_for_api
    end

    def legislation_proposal(id:)
      Legislation::Proposal.find(id)
    end

    def proposals
      Proposal.public_for_api
    end

    def proposal(id:)
      Proposal.find(id)
    end

    def proposal_notifications
      ProposalNotification.public_for_api
    end

    def proposal_notification(id:)
      ProposalNotification.find(id)
    end

    def tags
      Tag.public_for_api
    end

    def tag(id:)
      Tag.find(id)
    end

    def users
      User.public_for_api
    end

    def user(id:)
      User.find(id)
    end

    def votes
      Vote.public_for_api
    end

    def vote(id:)
      Vote.find(id)
    end
  end
end
