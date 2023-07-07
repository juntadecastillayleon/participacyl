require_dependency Rails.root.join("app", "graphql", "types", "query_type")

module Types
  class QueryType
    field :legislation_processes, Types::LegislationProcessType.connection_type,
          "Returns all legislation processes", null: false do
      argument :tag, String, required: false, default_value: nil
    end
    field :legislation_process, Types::LegislationProcessType,
          "Returns legislation process for ID", null: false do
      argument :id, ID, required: true, default_value: false
    end

    field :legislation_proposals, Types::LegislationProposalType.connection_type,
          "Returns all legislation proposals", null: false
    field :legislation_proposal, Types::LegislationProposalType,
          "Returns legislation proposal for ID", null: false do
      argument :id, ID, required: true, default_value: false
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
  end
end
