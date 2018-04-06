require 'clients/stripe/base'

module Clients
  module Stripe
    class UpdateSubscription < Base
      def initialize(stripe_subscription_class:, logger:)
        @stripe_subscription_class = stripe_subscription_class
        super(logger: logger)
      end

      def call(subscription:)
        stripe_sub = retrieve_subscription(subscription.stripe_id)
        @logger.debug "Updating Stripe Subscription with id:#{stripe_sub.id}"
        items = build_subscription_items(subscription, stripe_sub)
        @logger.debug "\tItems => #{items}"
        stripe_sub.items = items
        stripe_sub.save

        create_response(success: true, record: stripe_sub)
      rescue StandardError => e
        log_error(err: e)
        create_response(success: false, record: stripe_sub)
      end

      private

      def retrieve_subscription(id)
        @stripe_subscription_class.retrieve(id)
      end

      def build_subscription_items(sub, stripe_sub)
        [
          upsert_subscription_items(sub),
          delete_missing_subscription_items(sub.subscription_items, stripe_sub.items)
        ].flatten.compact
      end

      def upsert_subscription_items(sub)
        sub.subscription_items.map do |item|
          if item.stripe_id.nil?
            { plan: item.plan.stripe_id, quantity: item.quantity }
          else
            { id: item.stripe_id, quantity: item.quantity }
          end
        end
      end

      def delete_missing_subscription_items(sub_items, items)
        items.map do |item|
          { id: item.id, deleted: true } if sub_items.find_by(stripe_id: item.id).nil?
        end
      end
    end
  end
end
