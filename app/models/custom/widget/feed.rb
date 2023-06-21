require_dependency Rails.root.join("app", "models", "widget", "feed").to_s

class Widget::Feed
  def processes
    Legislation::Process.published.order("created_at DESC").limit(limit)
  end
end
