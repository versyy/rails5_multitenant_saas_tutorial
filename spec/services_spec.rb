require 'rails_helper'

RSpec.describe Services do
  subject { described_class }

  specify { expect(subject.cancel_subscription).to    be_a(Services::CancelSubscription) }
  specify { expect(subject.create_payment_source).to  be_a(Services::CreatePaymentSource) }
  specify { expect(subject.create_plan).to            be_a(Services::CreatePlan) }
  specify { expect(subject.create_product).to         be_a(Services::CreateProduct) }
  specify { expect(subject.create_subscription).to    be_a(Services::CreateSubscription) }
  specify { expect(subject.register_account).to       be_a(Services::RegisterAccount) }
  specify { expect(subject.update_product).to         be_a(Services::UpdateProduct) }
  specify { expect(subject.update_subscription).to    be_a(Services::UpdateSubscription) }
  specify { expect(subject.verify_payment_source).to  be_a(Services::VerifyPaymentSource) }
end
