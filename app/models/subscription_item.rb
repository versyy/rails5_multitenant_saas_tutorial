class SubscriptionItem < ApplicationRecord
  belongs_to :subscription
  belongs_to :plan
end
