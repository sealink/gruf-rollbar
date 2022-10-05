# frozen_string_literal: true

class ThingRequest
  attr_reader :uuid, :kind

  def initialize(uuid, kind)
    @uuid = uuid
    @kind = kind
  end

  def to_h
    {uuid: uuid, kind: kind}
  end
end

class ThingService; end

module Gruf
  module Rollbar
    module SpecHelpers
      def grpc_active_call(metadata: {}, output_metadata: {})
        double(:active_call, metadata: metadata, output_metadata: output_metadata)
      end

      def grpc_request
        ThingRequest.new('some uuid', 'some kind')
      end
    end
  end
end
