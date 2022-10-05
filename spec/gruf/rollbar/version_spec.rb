# frozen_string_literal: true

require 'spec_helper'

describe Gruf::Rollbar do
  describe 'version' do
    it 'should have a version' do
      expect(described_class::VERSION).to be_a(String)
    end
  end
end
