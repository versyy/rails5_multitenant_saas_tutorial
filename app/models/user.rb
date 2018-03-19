class User < ApplicationRecord
  rolify
  acts_as_tenant(:account)
  after_create :assign_default_role
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  def safe_attributes
    {
      first_name: first_name,
      last_name: last_name,
      email: email,
      last_sign_in_at: last_sign_in_at,
      updated_at: updated_at,
      created_at: created_at
    }
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  private

  def assign_default_role
    if account.users.count == 1 && roles.blank?
      add_role(:owner, account)
    else
      add_role(:member, account)
    end
  end
end
