class Account < ApplicationRecord
  WEBSITE_REGEX = /\A\b((?=[a-z0-9-]{1,63}\.)(xn--)?[a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,63}\b\z/
  validates_format_of :website, with: WEBSITE_REGEX
  validates_presence_of :name
  validates_uniqueness_of :website, allow_nil: true
end
