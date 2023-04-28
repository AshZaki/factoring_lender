class InvoiceAccrueFeeJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Invoice.where(status: 'purchased').find_each do |invoice|
      invoice.accrue_fee!
    end
    self.class.set(wait: 30.seconds).perform_later
  end
end
