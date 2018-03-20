class CreateSubscriptionItems < ActiveRecord::Migration[5.1]
  def change
    create_table :subscription_items, id: :uuid do |t|
      t.references :subscription, foreign_key: true
      t.references :plan, foreign_key: true
      t.string :stripe_id
      t.integer :quantity

      t.timestamps
    end
  end
end
