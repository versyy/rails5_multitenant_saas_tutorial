class User < ApplicationRecord
  rolify
  acts_as_tenant(:account, optional: true)
  after_create :assign_default_role
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  private

  def assign_default_role
    add_role(:member, account) unless account.nil?
  end
end
