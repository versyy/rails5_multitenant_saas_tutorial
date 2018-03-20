class CreatePlans < ActiveRecord::Migration[5.1]
  def change
    create_table :plans, id: :uuid do |t|
      t.string  :name,              null:     false
      t.string  :stripe_id,         null:     false
      t.integer :amount,            default:  0
      t.string  :currency,          default:  'usd'
      t.string  :interval,          default:  'month'
      t.integer :interval_count,    default:  1
      t.integer :trial_period_days, default:  0
      t.boolean :active,            default:  true
      t.boolean :displayable,       default:  true
      t.boolean :integrations,      default:  false
      t.integer :users

      t.timestamps
    end
  end
end
