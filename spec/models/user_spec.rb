require 'rails_helper'

RSpec.describe User, type: :model do
  
  it "name,emailがある場合" do
    user = FactoryBot.build(:user)
    expect(user).to be_valid
  end

  it "nameが無い場合、無効" do
    user = FactoryBot.build(:user, name: nil)
    user.valid?
    expect(user.errors[:name]).to include("can't be blank")
  end

  it "emailが無い場合、無効" do
    user = FactoryBot.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it "name,emailどちらも無い場合、無効" do
    user = FactoryBot.build(:user, name: nil, email: nil)
    user.valid?
    expect(user.errors[:name]).to include("can't be blank")
    expect(user.errors[:email]).to include("can't be blank")        
  end

  it "emailが重複した場合、無効" do
    user1 = FactoryBot.create(:user)
    user2 = FactoryBot.build(:user)
    user2.valid?
    expect(user2.errors[:email]).to include("has already been taken")
  end

  it "emailがアドレス以外の文字入力された場合、無効" do
    user = FactoryBot.build(:user, email: "12345")
    user.valid?
    expect(user.errors[:email]).to include("is invalid") 
  end
end
