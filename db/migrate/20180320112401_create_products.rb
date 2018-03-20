class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products, id: :uuid do |t|
      t.string :name,                 null: false
      t.string :description
      t.string :stripe_id
      t.string :stripe_type,          default: 'service'
      t.string :statement_descriptor
      t.string :unit_label

      t.timestamps
    end
  end
end
