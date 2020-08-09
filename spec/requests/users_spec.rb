require 'rails_helper'

RSpec.describe '/users', type: :request do
  # FactoryBotで作ったアカウントを作成、DBに保存 :valid_attributesは変数名（有効な属性）
  let(:valid_attributes) { FactoryBot.create(:user) }
  # FactoryBotで作ったアカウントをベースとして作成、DBには保存せず:invalid_attributesは変数名（有効ではない属性）
  let(:invalid_attributes) { FactoryBot.build(:user, name: nil, email: 'suzuki@example.com') }

  describe 'GET /index' do
    it 'renders a successful response' do
      # get通信をして、その結果が成功することを期待
      get users_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      # userを作成しget通信をして、showのページに遷移することが成功することを期待
      user = valid_attributes
      get user_url(user)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      # newへget通信をして、その結果が成功することを期待
      get new_user_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'render a successful response' do
      # userを作成しeditへget通信をして、editへ遷移することが成功することを期待
      user = valid_attributes
      get edit_user_url(user)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    # 有効なデータを扱う
    context 'with valid parameters' do
      it 'creates a new User' do
        # userを作成しpost通信をして、ユーザーのデータが１つ増える（つまり保存される）ことを期待
        expect do
          user = valid_attributes
          # ストロングパラメーターにデータを入れるために、こんな書き方になりました
          post users_url, params: { user: { name: user.name, email: user.email } }
        end.to change(User, :count).by(1)
      end

      it 'redirects to the created user' do
        # userを作成しpost通信をして、新規登録されることを期待
        # buildなのはcontroller無いでDBに保存する過程があるため。emailの一意性で弾かれる様
        user = FactoryBot.build(:user)
        post users_url, params: { user: { name: user.name, email: user.email } }
        expect(response).to redirect_to(user_url(User.last))
      end
    end

    # 有効では無いデータを扱う
    context 'with invalid parameters' do
      it 'does not create a new User' do
        # userを作成しpost通信をして、有効では無いため、DBの値は変化しないことを確認
        # ここでinvalid_attributesがcreateだと変数を定義した時点でvalidateで弾かれるのでうまくいかない
        expect do
          user = invalid_attributes
          post users_url, params: { user: { name: user.name, email: user.email } }
        end.to change(User, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        # userを作成しpost通信をして、その反応が成功することを期待
        user = invalid_attributes
        post users_url, params: { user: { name: user.name, email: user.email } }
        expect(response).to be_successful
      end
    end
  end

  describe 'PATCH /update' do
    # 有効なパラメーター
    context 'with valid parameters' do
      # 更新の確認なので新しく:new_attributesを定義
      let(:new_attributes) { FactoryBot.build(:user, name: 'sasaki', email: 'sasaki@example.com') }

      it 'updates the requested user' do
        # user,user2を作成しpatch通信をして、データを更新、更新後の名前を＝で確認
        # ここもcontroller無いでupdateがあるのでbuildにする
        user = valid_attributes
        user2 = new_attributes
        patch user_url(user.id), params: { user: { name: user2.name, email: user2.email } }
        user.reload
        expect(user.name).to eq 'sasaki'
      end

      it 'redirects to the user' do
        # user,user2を作成しpatch通信をして、データを更新、更新後のshowのページへredirectすることを期待
        user = valid_attributes
        user2 = new_attributes
        patch user_url(user.id), params: { user: { name: user2.name, email: user2.email } }
        user.reload
        expect(response).to redirect_to(user_url(user))
      end
    end

    # 有効では無いパラメーター
    context 'with invalid parameters' do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        # user,user2を作成しpatch通信をして、有効でないデータで更新しようとしたらページ遷移をすることを期待
        user = valid_attributes
        user2 = invalid_attributes
        patch user_url(user), params: { user: { name: user2.name, email: user2.email } }
        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested user' do
      # userを作成しDELETE通信をして、DBのデータが１つ減ることを期待
      user = valid_attributes
      expect do
        delete user_url(user)
      end.to change(User, :count).by(-1)
    end

    it 'redirects to the users list' do
      # userを作成しDELETE通信をして、redirectすることを期待
      user = valid_attributes
      delete user_url(user)
      expect(response).to redirect_to(users_url)
    end
  end
end
