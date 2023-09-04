require_dependency Rails.root.join("app", "models", "widget", "feed").to_s

class Widget::Feed
  def consultation_open_processes
    Legislation::Process.open.published.tagged_with("ConsultaPrevia").
                         order("end_date ASC").
                         limit(limit)
  end

  def consultation_past_processes
    open_count = consultation_open_processes.count
    return Legislation::Process.none if open_count >= limit

    Legislation::Process.past.published.tagged_with("ConsultaPrevia").
                         order("end_date DESC").
                         limit(limit - open_count)
  end

  def participation_open_processes
    Legislation::Process.open.published.tagged_with("ParticipaciónCiudadana").
                         order("end_date ASC").
                         limit(limit)
  end

  def participation_past_processes
    open_count = participation_open_processes.count
    return Legislation::Process.none if open_count >= limit

    Legislation::Process.past.published.tagged_with("ParticipaciónCiudadana").
                         order("end_date DESC").
                         limit(limit - open_count)
  end
end
