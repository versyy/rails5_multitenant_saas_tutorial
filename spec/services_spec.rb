require 'rails_helper'

RSpec.describe Services do
  subject { described_class }

  it '#register_account' do
    expect(subject.register_account).to be_a(Services::RegisterAccount)
  end
end
