class CreateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions, id: :uuid do |t|
      t.references  :account,                 type: :uuid, foreign_key: true, null: false
      t.references  :user,                    type: :uuid, foreign_key: true, null: false
      t.string      :status
      t.datetime    :started_at
      t.string      :stripe_id
      t.uuid        :idempotency_key,         null: false, default: 'gen_random_uuid()'

      t.timestamps

      t.index [:stripe_id, :user_id]
    end
  end
end
