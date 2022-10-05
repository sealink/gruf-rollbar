# frozen_string_literal: true

require 'spec_helper'

describe Gruf::Rollbar::ClientInterceptor do
  let(:options) { {} }
  let(:signature) { 'get_thing' }
  let(:active_call) { grpc_active_call }
  let(:grpc_method_name) { 'ThingService.get_thing' }
  let(:request) do
    double(
      :request,
      method_key: signature,
      route_key: 'foo',
      type: 'bar',
      service: ThingService,
      rpc_desc: nil,
      active_call: active_call,
      request_class: ThingRequest,
      service_key: 'thing_service.thing_request',
      message: grpc_request,
      method_name: grpc_method_name
    )
  end
  let(:interceptor) { described_class.new(options) }

  describe '.call' do
    context 'when there is no error' do
      subject { interceptor.call(request_context: request) { true } }

      it 'should not report the error' do
        expect(::Rollbar).to_not receive(:error)
        expect { subject }.to_not raise_exception
      end
    end

    context 'when there is an exception' do
      let(:exception_class) { GRPC::Internal }
      let(:error_message) { 'Something went wrong' }
      let(:exception) { exception_class.new(error_message) }

      subject do
        interceptor.call(request_context: request) { raise exception }
      end

      context 'and is a valid gRPC error' do
        it 'should ' do
          expect(::Rollbar).to receive(:error).once.and_call_original
          expect { subject }.to raise_error(GRPC::Internal)
        end
      end

      context 'with an ignored method' do
        before do
          allow(::Gruf::Rollbar).to receive(:ignore_methods).and_return([grpc_method_name])
        end

        it 'should not report the error' do
          expect(::Rollbar).to_not receive(:error)
          expect { subject }.to raise_error(GRPC::Internal)
        end
      end
    end
  end
end
