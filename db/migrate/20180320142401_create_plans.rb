class CreatePlans < ActiveRecord::Migration[5.1]
  def change
    create_table :plans, id: :uuid do |t|
      t.references  :product,           type: :uuid, foreign_key: true, null: false
      t.string      :name,              null:     false
      t.string      :stripe_id
      t.integer     :amount,            default:  0
      t.string      :currency,          default:  'usd'
      t.string      :interval,          default:  'month'
      t.integer     :interval_count,    default:  1
      t.integer     :trial_period_days, default:  0
      t.boolean     :active,            default:  true
      t.boolean     :displayable,       default:  true

      t.timestamps

      t.index [:stripe_id, :product_id]
    end
  end
end
