require 'rails_helper'

RSpec.describe '/microposts', type: :request do
  let(:valid_attributes) { FactoryBot.create(:micropost) }
  let(:invalid_attributes) { FactoryBot.build(:micropost, content: nil) }
  let(:over_140) { FactoryBot.build(:micropost, :over_140) }

  describe 'GET /index' do
    it 'renders a successful response' do
      get microposts_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      micropost = valid_attributes
      get micropost_url(micropost)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_micropost_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'render a successful response' do
      micropost = valid_attributes
      get edit_micropost_url(micropost)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Micropost' do
        expect do
          micropost = FactoryBot.build(:micropost)
          post microposts_url, params: { micropost: { content: micropost.content, user_id: micropost.user_id } }
        end.to change(Micropost, :count).by(1)
      end

      it 'redirects to the created micropost' do
        micropost = FactoryBot.build(:micropost)
        post microposts_url, params: { micropost: { content: micropost.content, user_id: micropost.user_id } }
        expect(response).to redirect_to(micropost_url(Micropost.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Micropost' do
        expect do
          micropost = invalid_attributes
          post microposts_url, params: { micropost: { content: micropost.content, user_id: micropost.user_id } }
        end.to change(Micropost, :count).by(0)
      end

      it 'does not create a new Micropost over 140' do
        expect do
          micropost = over_140
          post microposts_url, params: { micropost: { content: micropost.content, user_id: micropost.user_id } }
        end.to change(Micropost, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        micropost = invalid_attributes
        post microposts_url, params: { micropost: { content: micropost.content, user_id: micropost.user_id } }
        expect(response).to be_successful
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      it 'updates the requested micropost' do
        micropost = valid_attributes
        patch micropost_url(micropost), params: { micropost: { content: 'test content', user_id: micropost.user_id } }
        micropost.reload
        expect(micropost.content).to eq 'test content'
      end

      it 'redirects to the micropost' do
        micropost = valid_attributes
        patch micropost_url(micropost), params: { micropost: { content: 'test content', user_id: micropost.user_id } }
        micropost.reload
        expect(response).to redirect_to(micropost_url(micropost))
      end
    end

    context 'with invalid parameters' do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        micropost = valid_attributes
        patch micropost_url(micropost), params: { micropost: { content: nil, user_id: micropost.user_id } }
        expect(response).to be_successful
      end

      it "renders a successful response (i.e. to display the 'edit' template) over 140" do
        micropost = valid_attributes
        over = FactoryBot.build(:micropost, :over_140, user_id: micropost.user_id)
        patch micropost_url(micropost), params: { micropost: { content: over.content, user_id: over.user_id } }
        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested micropost' do
      micropost = valid_attributes
      expect do
        delete micropost_url(micropost)
      end.to change(Micropost, :count).by(-1)
    end

    it 'redirects to the microposts list' do
      micropost = valid_attributes
      delete micropost_url(micropost)
      expect(response).to redirect_to(microposts_url)
    end
  end
end
