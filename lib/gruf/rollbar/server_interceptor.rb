# frozen_string_literal: true

module Gruf
  module Rollbar
    ##
    # Intercepts inbound calls to provide Rollbar error reporting
    #
    class ServerInterceptor < Gruf::Interceptors::ServerInterceptor
      include Gruf::Rollbar::ErrorParser

      ##
      # Handle the gruf around hook and capture errors
      #
      def call(&_block)
        return yield if Gruf::Rollbar.ignore_methods.include?(request.method_name)

        begin
          yield
        rescue StandardError, GRPC::BadStatus => e
          if error?(e) # only capture
            ::Rollbar.scoped({
                               grpc_method: request.method_key,
                               grpc_request_class: request.request_class.name,
                               grpc_service_key: request.service_key,
                               grpc_error_code: code_for(e),
                               grpc_error_class: e.class.name
                             }) do
              ::Rollbar.error(e)
            end
          end
          raise # passthrough
        end
      end

      private

      ##
      # @return [Hash]
      #
      def request_message_params
        return {} if request.client_streamer? || !request.message.respond_to?(:to_h)

        request.message.to_h
      end
    end
  end
end
