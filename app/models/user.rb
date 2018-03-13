class User < ApplicationRecord
  rolify
  acts_as_tenant(:account)
  after_create :assign_default_role
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  private

  def assign_default_role
    if account.users.count == 1 && roles.blank?
      add_role(:owner, account)
    else
      add_role(:member, account)
    end
  end
end
