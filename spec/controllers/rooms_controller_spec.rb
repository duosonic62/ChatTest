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
        expect(flash[:created_room_id]).to match(/.{8,12}/)
      end
    end

    context 'room作成に失敗した場合' do
      before do
        login_user alice
        # @roomオブジェクト作成時空のインスタンスを渡してsaveを失敗させる
        allow(Room).to receive(:new).and_return(Room.new())
        get :new
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

      it 'flashに作成に失敗したメッセージが含まれていること' do
        expect(flash[:alert]).to eq("Room ID can't create. Try again.")
      end
    end
  end

  describe 'Post #show' do
    context 'リクエストパラメータのroom_idが存在した場合' do
      let(:params) do { 
        room: {
           room_id: room[:room_id]
          }
       }
      end

      let(:room) { message.room }

      let(:message) { create(:message_to_bob) }

      before do
        params
        login_user alice
      end

      it 'レスポンスコードが200であること' do
        post(:show, params: params)
        expect(response).to have_http_status(:ok)
      end

      it 'showテンプレートをレンダリングすること' do
        expect(post :show, params: params).to render_template :show
      end

      it 'ルームのメッセージが取得されていること' do
        post(:show, params: params)
        expect(assigns(:messages)).to eq [message]
      end
    end

    context 'リクエストパラメータのroom_idが存在しなかった場合' do
      let(:params) do { 
        room: {
           room_id: 'invalid_room_id'
          }
       }
      end

       before do
        login_user alice
        post(:show, params: params)
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

      it 'flashにルームIDが間違っているというメッセージが含まれていること' do
        expect(flash[:alert]).to eq('Not a valid room id.')
      end
    end

  end
end
