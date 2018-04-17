class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts, id: :uuid do |t|
      t.string :company
      t.string :website

      t.timestamps
    end
  end
end
