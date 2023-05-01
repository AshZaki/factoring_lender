class AddPurchasedAtToInvoices < ActiveRecord::Migration[7.0]
  def change
    add_column :invoices, :purchased_at, :datetime
  end
end
