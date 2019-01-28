require 'rails_helper'

RSpec.describe DeleteChannel, type: :channel do
  let(:message) { create(:message_to_bob) }
  let(:user) { message.user }
  let(:room) { message.room }

  before do
    # identifiersでコネクションをイニシャライズ
    stub_connection user_id: user.id
  end

  context '#subscribes' do
    it 'ストリーミングを開始すること' do
      subscribe()
      expect(subscription).to be_confirmed
      expect(subscription).to have_stream_from('delete_channel')
    end
  end

  context '#delete' do
    let(:alice) { create(:alice) }
    before do
      # コネクションのスタブにcurrent_userメソッドを追加する
      class ActionCable::Channel::ConnectionStub
        def current_user
          user
        end
      end
    end

    it 'メッセージが削除されること' do
      subscribe()
      allow(connection).to receive(:current_user).and_return(user)
      expect(ActionCable).to receive_message_chain(:server, :broadcast)
      expect{ perform :delete, id: message.id }.to change(Message, :count).by(-1)
    end

    it 'メッセージのIDが不正な場合は削除されないこと' do
      subscribe()
      # メッセージ送信者以外のuser(alice)をcurrent_userに返させて、削除を失敗させる
      allow(connection).to receive(:current_user).and_return(alice)
      perform :delete, id: message.id
      expect(subscription).to be_rejected
    end
  end
end
