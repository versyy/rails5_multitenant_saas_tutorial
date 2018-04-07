require 'rails_helper'

RSpec.describe Clients::Stripe do
  subject { described_class }

  specify { expect(subject.create_product).to         be_a(described_class::CreateProduct) }
  specify { expect(subject.create_plan).to            be_a(described_class::CreatePlan) }
  specify { expect(subject.create_subscription).to    be_a(described_class::CreateSubscription) }
end
