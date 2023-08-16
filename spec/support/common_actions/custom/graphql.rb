module Graphql
  def execute(query_string, context = {}, variables = {})
    context.merge!(request: ActionDispatch::TestRequest.create({ "HTTP_HOST" => "test" }))
    ConsulSchema.execute(query_string, context: context, variables: variables)
  end

  def dig(response, path)
    response.dig(*path.split("."))
  end

  def hidden_field?(response, field_name)
    data_is_empty = response["data"].nil?
    error_is_present = ((response["errors"].first["message"] =~ /Field '#{field_name}' doesn't exist on type '[[:alnum:]]*'/) == 0)
    data_is_empty && error_is_present
  end

  def extract_fields(response, collection_name, field_chain)
    fields = field_chain.split(".")
    dig(response, "data.#{collection_name}.edges").map do |node|
      begin
        if fields.size > 1
          node["node"][fields.first][fields.second]
        else
          node["node"][fields.first]
        end
      rescue NoMethodError
      end
    end.compact
  end
end
