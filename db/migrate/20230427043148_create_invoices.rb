class CreateInvoices < ActiveRecord::Migration[7.0]
  def change
    create_table :invoices do |t|
      t.string :invoice_number, null: false, unique: true
      t.decimal :invoice_amount, null: false
      t.date :due_date, null: false
      t.integer :status, null: false, default: 0
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end
