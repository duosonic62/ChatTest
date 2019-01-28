require 'rails_helper'

RSpec.describe RoomChannel, type: :channel do
  let(:message) { create(:message_to_bob) }
  let(:user) { message.user }
  let(:room) { message.room }

  before do
    # identifiersでコネクションをイニシャライズ
    stub_connection user_id: user.id
  end

  context '#subscribes' do
    it "room_idが存在しない場合はrejectすること" do
      subscribe
      expect(subscription).to be_rejected
    end

    it "room_idが存在する場合はストリーミングを開始すること" do
      subscribe({'room_id': 42})
      expect(subscription).to be_confirmed
      expect(subscription).to have_stream_from("room_channel_42")
    end
  end

  context '#speak' do
    before do
      # コネクションのスタブにcurrent_userメソッドを追加する
      class ActionCable::Channel::ConnectionStub
        def current_user
          user
        end
      end
    end

    it "messageが作成されること" do
      subscribe({'room_id': room.id})
      allow(connection).to receive(:current_user).and_return(user)
      expect{ perform :speak, message: 'new content' }.to change(Message, :count).by(1)
    end
  end
end
