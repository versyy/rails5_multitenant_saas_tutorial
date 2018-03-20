class Account < ApplicationRecord
  has_many :users
  has_many :subscriptions
  has_many :plans, through: :subscriptions
  validates_url :website, no_local: true
  validates_presence_of :company
  validates_uniqueness_of :website, allow_nil: true
  resourcify
end
