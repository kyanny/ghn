require 'spec_helper'

describe Ghn do
  let(:access_token) { SecureRandom.hex }

  describe '#initialize' do
    context 'if no arguments is passed' do
      it 'should raise error' do
        expect { described_class.new }.to raise_error
      end
    end

    context 'if access_token argument is passed' do
      it 'should not raise error' do
        expect { described_class.new(access_token) }.to_not raise_error
      end
    end
  end
end
