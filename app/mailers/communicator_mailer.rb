class CommunicatorMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers

  default from: 'support@versyy.com'

  def confirmation_instructions(record, token, opts = {})
    template_id = opts[:template_id] || 'tem_Y4pgfmHBMFY8Wd9bqdfKgC3H'
    payload = {
      user: record.safe_attributes,
      account: record.account.attributes,
      confirmation_link: confirmation_url(record, confirmation_token: token)
    }

    deliver(template_id, record.email, payload)
  end

  def reset_password_instructions(record, token, opts = {})
    template_id = opts[:template_id] || 'tem_pgXYdY9StyfGKp4PQ3qGXdC3'
    payload = {
      user: record.safe_attributes,
      account: record.account.attributes,
      reset_password_link: edit_password_url(record, reset_password_token: token)
    }

    deliver(template_id, record.email, payload)
  end

  # Uncomment below if you add :Unlockable module for device
  #
  # def unlock_instructions(record, token, opts = {})
  #   template_id = opts[:template_id] || 'tem_DrcP6SSmGbtTWy8R6wHMPK7P'
  #   payload = {
  #     user: record.attributes,
  #     unlock_link: unlock_url(record, unlock_token: token)
  #   }
  #
  #   deliver(template_id, record.email, payload)
  # end

  def email_changed(record, opts = {})
    template_id = opts[:template_id] || 'tem_43q99PcVygRqVdSTc8PWdhfX'
    payload = {
      user: record.safe_attributes,
      account: record.account.attributes
    }

    deliver(template_id, record.email, payload)
  end

  def password_change(record, opts = {})
    template_id = opts[:template_id] || 'tem_kcQ6cjdSrhFXyqM44qrFcJpS'
    payload = {
      user: record.safe_attributes,
      account: record.account.attributes
    }

    deliver(template_id, record.email, payload)
  end

  def invitation_instructions(record, token, opts = {})
    template_id = opts[:template_id] || 'tem_kj8jTcwRDtBPW3cMG3jFJDVd'
    payload = {
      user: record.safe_attributes,
      account: record.account.attributes,
      accept_invitation_link: accept_invitation_url(record, invitation_token: token)
    }

    deliver(template_id, record.email, payload)
  end

  def new_subscription_plan(subscription, opts = {})
    template_id = opts[:template_id] || 'tem_'
    payload = {
      subscription: subscription.attributes,
      user: subscription.user.safe_attributes,
      account: subscription.user.account.attributes
    }

    deliver(template_id, subscription.user.email, payload)
  end

  def upgrade_subscription_plan(subscription, old_amount, opts = {})
    template_id = opts[:template_id] || 'tem_'
    payload = {
      subscription: subscription.attributes,
      old_amount: old_amount,
      user: subscription.user.safe_attributes,
      account: subscription.user.account.attributes
    }

    deliver(template_id, subscription.user.email, payload)
  end

  def cancel_subscription_plan(subscription, opts = {})
    template_id = opts[:template_id] || 'tem_'
    payload = {
      subscription: subscription.attributes,
      user: subscription.user.safe_attributes,
      account: subscription.user.account.attributes
    }

    deliver(template_id, subscription.user.email, payload)
  end

  private

  def communicator_client
    @communicator_client ||= Versyy::Communicator.client
  end

  def deliver(template_id, address, payload)
    communicator_client.deliver_msg(
      template_id: template_id,
      to: { address: address },
      payload: payload
    )
  rescue Versyy::Communicator::Error => e
    puts "Error - #{e.class.name}: #{e.message}"
  end
end
