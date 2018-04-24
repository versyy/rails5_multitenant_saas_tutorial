class Plan < ApplicationRecord
  belongs_to :product
  has_many :subscription_items
  has_many :subscriptions, through: :subscription_items
end
