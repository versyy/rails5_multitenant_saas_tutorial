class Ability
  include CanCan::Ability

  def initialize(user)
    if user.is_admin?
      apply_admin_permissions
    elsif user.is_owner?
      apply_permissions(user, :manage)
    elsif user.is_member?
      apply_permissions(user, :read)
    end
  end

  private

  def apply_permissions(user, permission)
    can permission, Account, id: user.account_id
    can permission, User, account_id: user.account_id
    can permission, Role, id: user.account.users.map(&:role_ids).flatten
  end

  def apply_admin_permissions
    can :manage, Account
    can :manage, User
    can :manage, Role
  end
end
