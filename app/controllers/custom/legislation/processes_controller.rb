require_dependency Rails.root.join("app", "controllers", "legislation", "processes_controller").to_s

class Legislation::ProcessesController
  include Search

  alias_method :consul_index, :index

  def index
    consul_index
    @processes = @processes.search(@search_terms) if @search_terms.present?
    @processes = @processes.filter_by(@advanced_search_terms)
    @tags = Tag.where(name: Legislation::Process::CATEGORIES)
  end
end
