require 'rails_helper'

RSpec.describe Client, type: :model do
  describe "associations" do
    it { should have_many(:invoices) }
  end

end
