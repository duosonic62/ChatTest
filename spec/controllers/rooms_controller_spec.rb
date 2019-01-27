require 'rails_helper'

RSpec.describe RoomsController, type: :controller do
  let(:alice) { create(:alice) }

  describe 'GET #index' do
    before do
      login_user alice
      get :index
    end

    it 'レスポンスコードが200であること' do
      expect(response).to have_http_status(:ok)
    end

    it 'indexテンプレートをレンダリングすること' do
      expect(response).to render_template :index
    end

    it '空のroomオブジェクトが渡されれること' do
      expect(assigns(:room)).to be_a_new Room
    end
  end

  describe 'Get #new' do
    context 'room作成に成功した場合' do
      before do
        login_user alice
        get :new
      end
      
      it 'レスポンスコードが200であること' do
        expect(response).to have_http_status(:ok)
      end

      it 'indexテンプレートをレンダリングすること' do
        expect(response).to render_template :index
      end

      it '空でないroomオブジェクトが渡されれること' do
        expect(assigns(:room)).not_to be_a_new Room
      end

      it 'flashに作成メッセージが含まれていること' do
        binding.pry
        expect(flash[:created_room_id]).to match(/.{8,12}/)
      end
    end

    context 'room作成に失敗した場合' do
      it 'レスポンスコードが200であること' do
        expect(response).to have_http_status(:ok)
      end

      it 'indexテンプレートをレンダリングすること' do
        expect(response).to render_template :index
      end

      it '空でないroomオブジェクトが渡されれること' do
        expect(assigns(:room)).not_to be_a_new Room
      end

      it 'flashに作成メッセージが含まれていること' do
        binding.pry
        expect(flash[:created_room_id]).to match(/.{8,12}/)
      end
    end
  end

  describe 'Post #show' do

  end
end
