# frozen_string_literal: true

require 'spec_helper'

describe Gruf::Rollbar do
  describe '.configure' do
    let(:configuration) { described_class  }
    subject(:configure) { configuration.configure(&block) }

    before { described_class.reset }
    after { described_class.reset }

    context 'when no values are overridden' do
      let(:block) { Proc.new { |config|  } }

      it 'has default values' do
        configure

        expect(configuration.default_error_code).to eq(GRPC::Core::StatusCodes::INTERNAL)
        expect(configuration.options).to include(default_error_code: GRPC::Core::StatusCodes::INTERNAL)
      end
    end

    context 'when values are overridden' do
      let(:block) do
        Proc.new { |config|
          config.default_error_code = GRPC::Core::StatusCodes::UNKNOWN
        }
      end

      it 'has overridden values' do
        configure

        expect(configuration.default_error_code).to be(GRPC::Core::StatusCodes::UNKNOWN)
        expect(configuration.options).to include(default_error_code: GRPC::Core::StatusCodes::UNKNOWN)
      end
    end
  end
end
