require 'rails_helper'

RSpec.describe Micropost, type: :model do
  it 'content,user_idがある場合' do
    micropost = FactoryBot.build(:micropost)
    expect(micropost).to be_valid
  end

  it 'contentが無い場合、無効' do
    micropost = FactoryBot.build(:micropost, content: nil)
    micropost.valid?
    expect(micropost.errors[:content]).to include("can't be blank")
  end

  it 'user_idが無い場合、無効' do
    micropost = FactoryBot.build(:micropost, user_id: nil)
    micropost.valid?
    expect(micropost.errors[:user_id]).to include("can't be blank")
  end

  it 'content,user_idどちらも無い場合、無効' do
    micropost = FactoryBot.build(:micropost, content: nil, user_id: nil)
    micropost.valid?
    expect(micropost.errors[:content]).to include("can't be blank")
    expect(micropost.errors[:user_id]).to include("can't be blank")
  end

  it 'contentが140文字を超えた場合、無効' do
    micropost = FactoryBot.build(:micropost, :over_140)
    micropost.valid?
    expect(micropost.errors[:content]).to include('is too long (maximum is 140 characters)')
  end

  it 'contentが140文字の場合、有効' do
    micropost = FactoryBot.build(:micropost, :just_140)
    expect(micropost).to be_valid
  end

  it 'contentが140文字以内場合、有効' do
    micropost = FactoryBot.build(:micropost, :below_140)
    expect(micropost).to be_valid
  end
end
