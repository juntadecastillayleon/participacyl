require_dependency Rails.root.join("app", "graphql", "types", "user_type")

module Types
  class UserType
    field :last_sign_in_at, GraphQL::Types::ISO8601DateTime, null: true
  end
end
