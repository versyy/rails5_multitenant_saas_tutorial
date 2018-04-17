class Account < ApplicationRecord
  validates_url :website, no_local: true
  validates_presence_of :company
  validates_uniqueness_of :website, allow_nil: true
end
