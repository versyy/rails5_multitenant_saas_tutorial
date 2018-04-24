class Subscription < ApplicationRecord
  belongs_to :account
  belongs_to :user
  has_many :subscription_items
  has_many :plans, through: :subscription_items
end
