require_dependency Rails.root.join("app", "controllers", "admin", "legislation", "processes_controller").to_s

class Admin::Legislation::ProcessesController
  alias_method :consul_allowed_params, :allowed_params

  def allowed_params
    consul_allowed_params + [:tag_list]
  end
end
