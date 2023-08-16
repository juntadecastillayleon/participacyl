require_dependency Rails.root.join("app", "controllers", "graphql_controller")

class GraphqlController
  def execute
    begin
      raise GraphqlController::QueryStringError if query_string.nil?

      result = ConsulSchema.execute(query_string,
        variables: prepare_variables,
        context: {
          request: request
        },
        operation_name: params[:operationName]
      )
      render json: result
    rescue GraphqlController::QueryStringError
      render json: { message: "Query string not present" }, status: :bad_request
    rescue JSON::ParserError
      render json: { message: "Error parsing JSON" }, status: :bad_request
    rescue GraphQL::ParseError
      render json: { message: "Query string is not valid JSON" }, status: :bad_request
    rescue ArgumentError => e
      render json: { message: e.message }, status: :bad_request
    end
  end
end
