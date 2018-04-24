class CreateSubscriptionItems < ActiveRecord::Migration[5.1]
  def change
    create_table :subscription_items, id: :uuid do |t|
      t.references :subscription, type: :uuid, foreign_key: true, null: false
      t.references :plan,         type: :uuid, foreign_key: true, null: false
      t.string  :stripe_id
      t.integer :quantity

      t.timestamps

      t.index [:stripe_id, :subscription_id]
      t.index [:plan_id, :subscription_id]
      t.index [:subscription_id, :plan_id]
    end
  end
end
