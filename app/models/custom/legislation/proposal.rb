require_dependency Rails.root.join("app", "models", "legislation", "proposal").to_s

class Legislation::Proposal < ApplicationRecord
  include Graphqlable

  skip_validation :summary, :presence
  skip_validation :title, :length

  validates :title, length: { in: 1..140 }

  scope :public_for_api, -> { all }
end
