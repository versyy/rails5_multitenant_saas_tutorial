require 'rails_helper'

RSpec.describe Clients::Stripe do
  subject { described_class }

  specify { expect(subject.create_product).to         be_a(described_class::CreateProduct) }
end
