require_dependency Rails.root.join("app", "models", "legislation", "proposal").to_s

class Legislation::Proposal < ApplicationRecord
  skip_validation :summary, :presence
  skip_validation :title, :length

  validates :title, length: { in: 1..140 }
end
