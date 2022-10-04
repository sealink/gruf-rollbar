# frozen_string_literal: true

module Gruf
  module Rollbar
    ##
    # Mixin for error parsing
    #
    module ErrorParser
      ##
      # @param [StandardError]
      # @return [Number] that maps to one of the GRPC::Core::StatusCodes or Gruf::Rollbar.default_error_code
      #
      def code_for(error)
        error.respond_to?(:code) ? error.code : Gruf::Rollbar.default_error_code
      end

      ##
      # @return [Boolean]
      #
      def error?(exception)
        error_classes.include?(exception.class.to_s)
      end

      ##
      # @return [Array]
      #
      def error_classes
        @options.fetch(:error_classes, Gruf::Rollbar.grpc_error_classes)
      end
    end
  end
end
