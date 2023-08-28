require_dependency Rails.root.join("app", "models", "widget", "feed").to_s

class Widget::Feed
  def processes
    #Legislation::Process.published.order("created_at DESC").limit(limit)
    Legislation::Process.published.order("end_date ASC").limit(limit)
    published =  Legislation::Process.published.where.not("end_date < ?", Date.current)
    if published.count >= 10
      published.order("end_date ASC").limit(limit)
    else
      # published
    end
    open_processes = Legislation::Process.published.open
    closed_processes = Legislation::Process.published.past.tagged_with("Destacado")
    #Legislation::Process.published.open.or(past).order("end_date DESC").limit(limit)
    #render_at_homepage
    yeah = (open_processes + closed_processes)
    #debugger
    Legislation::Process.render_at_homepage.order("created_at DESC").limit(limit)
    #(open_processes + closed_processes).order("end_date DESC").limit(limit)
  end
end
