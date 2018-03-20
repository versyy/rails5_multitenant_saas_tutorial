class CreatePlans < ActiveRecord::Migration[5.1]
  def change
    create_table :plans, id: :uuid do |t|
      t.string :name
      t.string :stripe_id
      t.integer :amount
      t.string :currency
      t.string :interval
      t.integer :interval_count
      t.integer :trial_period_days
      t.boolean :active
      t.boolean :displayable
      t.boolean :integrations
      t.integer :users

      t.timestamps
    end
  end
end
