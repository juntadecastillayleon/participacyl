module Types
  class LegislationProcessType < Types::BaseObject
    alias_method :process, :object

    field :additional_info, String, null: true
    field :comments_count, Integer, null: false
    field :description, String, null: true
    field :end_date, GraphQL::Types::ISO8601Date, null: false
    field :homepage, String, null: true
    field :id, ID, null: false
    field :milestones_summary, String, null: true
    field :prompt, String, null: true
    field :proposals_count, Integer, null: false
    field :proposals_description, String, null: true
    field :proposals_phase_end_date, GraphQL::Types::ISO8601Date, null: true
    field :proposals_phase_start_date, GraphQL::Types::ISO8601Date, null: true
    field :public_created_at, String, null: true
    field :start_date, GraphQL::Types::ISO8601Date, null: false
    field :summary, String, null: true
    field :tags, Types::TagType.connection_type, null: true
    field :title, String, null: false
    field :votes_count, Integer, null: false

    def comments_count
      process.proposals.sum { |proposal| proposal.comments.count }
    end

    def proposals_count
      process.proposals.count
    end

    def tags
      process.tags.public_for_api
    end

    def votes_count
      process.proposals.sum(&:cached_votes_total)
    end
  end
end
