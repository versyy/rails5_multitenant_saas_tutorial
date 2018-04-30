require 'spec_helper'
require 'utils'

RSpec.describe Utils do
  let(:text) { 'text' }

  describe '#say_with_time' do
    subject { described_class.say_with_time(text) { 10 } }
    specify { expect { subject }.to output(/text/).to_stdout }
    specify { expect { subject }.to output(/10 rows/).to_stdout }
  end

  describe '#say' do
    let(:level) { :subitem }
    subject { described_class.say(text, level) }

    specify { expect { subject }.to output(/-> text/).to_stdout }

    context 'with level != :subitem' do
      let(:level) { :item }
      specify { expect { subject }.to output(/== text/).to_stdout }
    end
  end

  describe '#process_result' do
    let(:success) { true }
    let(:errors) { [StandardError.new('message')] }
    let(:result) { double(:result, success?: success, errors: errors) }
    subject { described_class.process_result(result) { 1 } }

    specify { expect(subject).to eq(1) }

    context 'when success is false' do
      let(:success) { false }

      specify { expect { subject }.to raise_error(StandardError) }
    end
  end
end
