class CreateInvoices < ActiveRecord::Migration[7.0]
  def change
    create_table :invoices do |t|
      t.string :invoice_number
      t.decimal :invoice_amount
      t.date :due_date
      t.integer :status
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end
