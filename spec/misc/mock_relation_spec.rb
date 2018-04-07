require 'spec_helper'
require 'support/active_record_helpers'
require 'active_record/errors'

RSpec.describe ActiveRecordHelpers::MockRelation do
  let(:ctxt) { described_class.new(1, item) }
  subject { ctxt }
  let(:val) { 1 }
  let(:item) { double(:item, id: val) }

  describe '#buildi(anything)' do
    specify { expect(subject.build(1)).to be(item) }
  end

  describe '#joins(anything)' do
    specify { expect(subject.joins(:table)).to be(ctxt) }
    specify { expect(subject.joins(:table)).to be_a(described_class) }
  end

  describe '#find(id)' do
    context 'when record with id exists' do
      specify { expect(subject.find(val)).to eq(item) }
    end

    context 'when no record with id matches' do
      it 'throws an ActiveRecord::NotFound' do
        expect { subject.find('something') }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe '#where(params)' do
    context 'when record with matching key and value exists' do
      specify { expect(subject.where(id: val)).to eq([item]) }
    end

    context 'when no record matches the key and value pair' do
      specify { expect(subject.where(id: 'something')).to eq([]) }
    end
  end
end
