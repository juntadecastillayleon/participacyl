require_dependency Rails.root.join("app", "models", "comment")

class Comment
  scope :public_for_api, -> do
    not_valuations
      .where(commentable: [Debate.public_for_api, Proposal.public_for_api, Poll.public_for_api,
                           Legislation::Proposal.public_for_api])
  end
end
