require 'services/base_service'
require 'services/error'

module Services
  class UpdateSubscription < BaseService
    Response = Struct.new(:success?, :subscription, :stripe_subscription, :errors)

    def initialize(subscription_class:, plan_class:, stripe_update_subscription_svc:, logger:)
      @subscription_class             = subscription_class
      @plan_class                     = plan_class
      @stripe_update_subscription_svc = stripe_update_subscription_svc
      super(logger: logger)
    end

    # Updates the subscription locally and with Stripe
    #
    # subscription_id:  String, # <= the ID of the subscription to be updated
    # params:           { subscription_items: [si_params]
    #                     ] }
    #
    # NOTE: si_params is a valid hash for Subscription.subscription_items.build(sub_item_params)
    #
    # returns:          Response object
    def call(subscription_id:, params:)
      subscription = @subscription_class.find(subscription_id)

      stripe_subscription = process_update(subscription, subscription_item_params(params))
      subscription.reload

      self.success = true
      create_response(subscription, stripe_subscription)
    rescue StandardError => e
      log_error(UpdateSubscriptionError.new(e))
      create_response(subscription, stripe_subscription)
    end

    private

    def process_update(subscription, sub_item_params)
      stripe_subscription = nil

      subscription.transaction do
        subscription = update_subscription_items(subscription, sub_item_params)
        subscription.reload
        stripe_subscription = update_stripe_subscription(subscription)
        update_subscription(subscription, stripe_subscription)
      end

      stripe_subscription
    end

    def update_stripe_subscription(sub)
      result = @stripe_update_subscription_svc.call(subscription: sub)
      raise UpdateSubscriptionError, result.errors.map(&:message) unless result.success?
      result.record
    end

    def update_subscription(sub, stripe_sub)
      sub.update!(
        status: stripe_sub.status
      )
    end

    def subscription_item_params(sub_params)
      sub_params[:subscription_items]
    end

    def update_subscription_items(sub, sub_item_params)
      sub_item_params.each do |item|
        upsert_subscription_item(sub.subscription_items, item)
      end

      sub.subscription_items.each do |i|
        i.destroy unless config_contains(sub_item_params, i.plan_id)
      end

      sub
    end

    def upsert_subscription_item(sub_items, item)
      sub_item = sub_items.select { |i| i.plan_id == item[:plan_id] }.first

      if sub_item.nil?
        sub_items.build(item).save # add if missing
      else
        sub_item.update!(item) # update existing with any changes
      end
    end

    def config_contains(config, plan_id)
      !config.select { |i| i[:plan_id] == plan_id }.empty?
    end

    def create_response(sub, stripe_sub)
      Response.new(success, sub, stripe_sub, errors)
    end
  end
end
