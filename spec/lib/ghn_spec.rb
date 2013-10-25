require 'spec_helper'

describe Ghn do
  let(:token) { double }
  let(:command) { double }
  let(:options) { double }

  describe '#initialize' do
    context 'if no arguments is passed' do
      it 'should raise error' do
        expect { described_class.new }.to raise_error
      end
    end

    context 'if token, command and options argument is passed' do
      it 'should not raise error' do
        expect { described_class.new(token, command, options) }.to_not raise_error
      end
    end
  end
end
