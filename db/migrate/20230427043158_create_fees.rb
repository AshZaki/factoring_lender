class CreateFees < ActiveRecord::Migration[7.0]
  def change
    create_table :fees do |t|
      t.references :invoice, null: false, foreign_key: true
      t.decimal :fee_amount, null: false
      t.date :fee_date, null: false
      t.timestamps
    end
    add_index :fees, :fee_date
  end
end
