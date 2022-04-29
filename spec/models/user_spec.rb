require 'rails_helper'

RSpec.describe User, type: :model do
  it '有 email' do
    user = User.new email: 'lifa.com'
    expect(user.email).to eq 'lifa.com'
  end
end
