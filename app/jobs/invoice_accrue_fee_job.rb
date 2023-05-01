class InvoiceAccrueFeeJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Invoice.where(status: 'purchased').find_each do |invoice|
      invoice.accrue_fee!
    end
  end
end
