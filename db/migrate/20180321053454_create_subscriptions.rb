class CreateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions, id: :uuid do |t|
      t.references :account, foreign_key: true
      t.references :user, foreign_key: true
      t.string :status
      t.datetime :started_at
      t.string :stripe_id
      t.uuid :idempotency_key

      t.timestamps
    end
  end
end
