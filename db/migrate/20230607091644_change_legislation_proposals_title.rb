class ChangeLegislationProposalsTitle < ActiveRecord::Migration[5.2]
  def up
    change_column :legislation_proposals, :title, :string, limit: nil
  end

  def down
    change_column :legislation_proposals, :title, :string, limit: 80
  end
end
