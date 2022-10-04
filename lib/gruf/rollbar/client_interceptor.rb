# frozen_string_literal: true

require 'pry'

module Gruf
  module Rollbar
    ##
    # Intercepts outbound calls to provide Rollbar reporting
    #
    class ClientInterceptor < Gruf::Interceptors::ClientInterceptor
      include Gruf::Rollbar::ErrorParser

      ##
      # @param [Gruf::Outbound::RequestContext]
      #
      def call(request_context:)
        return yield if Gruf::Rollbar.ignore_methods.include?(request_context.method_name)

        begin
          yield
        rescue StandardError, GRPC::BadStatus => e
          if error?(e) # only capture
            ::Rollbar.scoped({
                              grpc_method_name: request_context.method_name,
                              grpc_route_key: request_context.route_key,
                              grpc_error_code: code_for(e),
                              grpc_error_class: e.class.name
                            }) do
              ::Rollbar.error(e)
            end
          end
          raise # passthrough
        end
      end
    end
  end
end
