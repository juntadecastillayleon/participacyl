require_dependency Rails.root.join("app", "models", "legislation", "process").to_s

class Legislation::Process
  include Filterable
  scope :by_date_range, ->(date_range) { where(start_date: date_range).or(where(end_date: date_range)) }
end
