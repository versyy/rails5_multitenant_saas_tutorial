require 'rails_helper'

RSpec.describe Services do
  subject { described_class }

  specify { expect(subject.create_product).to         be_a(Services::CreateProduct) }
  specify { expect(subject.register_account).to       be_a(Services::RegisterAccount) }
end
