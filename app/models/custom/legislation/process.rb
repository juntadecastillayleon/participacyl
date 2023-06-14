require_dependency Rails.root.join("app", "models", "legislation", "process").to_s

class Legislation::Process
  include Filterable
  scope :by_date_range, ->(date_range) { where(start_date: date_range).or(where(end_date: date_range)) }

  CATEGORIES = ["ConsultaPrevia", "ParticipaciónCiudadana"].freeze

  alias_method :consul_searchable_values, :searchable_values

  def searchable_values
    {
      tag_list.join(" ") => "B"
    }.merge(consul_searchable_values)
  end
end
