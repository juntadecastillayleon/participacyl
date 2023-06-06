class AddPromptToLegislationProcessTranslations < ActiveRecord::Migration[5.2]
  def change
    add_column :legislation_process_translations, :prompt, :text
  end
end
