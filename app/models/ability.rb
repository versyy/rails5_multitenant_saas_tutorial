class Ability
  include CanCan::Ability

  def initialize(user)
    if user.has_role? :admin
      apply_admin_permissions
    elsif user.has_role? :owner, user.account
      apply_permissions(user, :manage)
    elsif user.has_role? :member, user.account
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
