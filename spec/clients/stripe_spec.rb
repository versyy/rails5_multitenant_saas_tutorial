require 'rails_helper'

RSpec.describe Clients::Stripe do
  subject { described_class }

  specify { expect(subject.cancel_subscription).to    be_a(described_class::CancelSubscription) }
  specify { expect(subject.create_payment_source).to  be_a(described_class::CreatePaymentSource) }
  specify { expect(subject.create_plan).to            be_a(described_class::CreatePlan) }
  specify { expect(subject.create_product).to         be_a(described_class::CreateProduct) }
  specify { expect(subject.create_subscription).to    be_a(described_class::CreateSubscription) }
  specify { expect(subject.update_product).to         be_a(described_class::UpdateProduct) }
  specify { expect(subject.update_subscription).to    be_a(described_class::UpdateSubscription) }

  specify do
    expect(subject.find_or_create_customer).to be_a(described_class::FindOrCreateCustomer)
  end
end
