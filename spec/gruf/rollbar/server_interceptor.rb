# frozen_string_literal: true

require 'spec_helper'

describe Gruf::Rollbar::ServerInterceptor do
  let(:service) { ThingService.new }
  let(:options) { {} }
  let(:signature) { 'get_thing' }
  let(:active_call) { grpc_active_call }
  let(:grpc_method_name) { 'ThingService.get_thing' }
  let(:request) do
    double(
      :request,
      method_key: signature,
      service: ThingService,
      rpc_desc: nil,
      active_call: active_call,
      request_class: ThingRequest,
      service_key: 'thing_service.thing_request',
      message: grpc_request,
      method_name: grpc_method_name
    )
  end
  let(:errors) { Gruf::Error.new }
  let(:span) { double(:span, set_tag: true) }
  let(:interceptor) { described_class.new(request, errors, options) }

  describe '.call' do
    before do
      allow(request).to receive(:client_streamer?).and_return(false)
    end

    context 'when there is no error' do
      subject { interceptor.call { true } }

      it 'should not report the error' do
        expect(::Rollbar).to_not receive(:error)
        expect { subject }.to_not raise_exception
      end
    end

    context 'when there is an exception' do
      let(:grpc_error_code) { :internal }
      let(:app_error_code) { :something_went_wrong }
      let(:exception_class) { StandardError }
      let(:error_message) { 'Something went wrong' }
      let(:exception) { exception_class.new(error_message) }

      subject do
        interceptor.call { interceptor.fail!(grpc_error_code, app_error_code, error_message) }
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
